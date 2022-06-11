#!/bin/bash
# 注意此脚本只适用于“5.6.x”版本
clear;
# 字体颜色（红色-绿色-黄色）
color_red='\033[0;31m'
color_green='\033[0;32m'
color_yellow='\033[0;33m'
color_end='\033[0m'
Info="${color_green}[信息]${color_end}"
Error="${color_red}[错误]${color_end}"
Tip="${color_yellow}[注意]${color_end}"

# echo颜色文字输出
red() {
    echo -e "\033[31m\033[01m$1\033[0m"
}
green() {
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow() {
    echo -e "\033[33m\033[01m$1\033[0m"
}
# 输出彩色提示信息(必须定义变量)
ShowColorTipsA(){
    echo -e "${color_yellow}${KeyTips}${color_end}"
}
# 输出彩色提示信息......(必须定义变量)
ShowColorTipsB(){
    echo -e "${color_yellow}${KeyTips}......${color_end}"
}
# 输出彩色双虚线
ShowColorDoubleDottedLine(){
    echo -e "${color_yellow}================================================${color_end}"
}
#=======================================

install_mysql_56(){
    KeyTips="软件包更新及依赖安装" && ShowColorTipsB
    apt-get update -y && apt-get upgrade -y
    apt-get install libaio1 -y
    apt -y install apt-file
    apt-file update
    apt-file find libncurses.so.5
    apt -y install libncurses5

    groupadd mysql -g 5001;
    useradd -s /sbin/nologin mysql -u 5001 -g 5001;
    mysql_download(){
        KeyTips="下载已编译好的“mysql-${mysql_ver}”文件" && ShowColorTipsB
        mysql_ver="5.6.51"
        mysql_ver_pre=${mysql_ver:0:3}

        chmod 660 ~/.wget-hsts
        wget https://cdn.mysql.com/archives/mysql-${mysql_ver_pre}/mysql-${mysql_ver}-linux-glibc2.12-x86_64.tar.gz;
        tar -zxf mysql-${mysql_ver}-linux-glibc2.12-x86_64.tar.gz;
        rm -rf mysql-${mysql_ver}-linux-glibc2.12-x86_64.tar.gz;
        mv -f mysql-${mysql_ver}-linux-glibc2.12-x86_64 /usr/local/mysql;

    }
    if [ -z "$(ls /root |grep "mysql-${mysql_ver}-linux-glibc2.12-x86_64.tar.gz")" ]; then
        mysql_download
    fi

    mkdir -p /home/mysql/data;
    chown -R mysql:mysql /home/mysql;
    rm -rf /etc/my.cnf;
cat >>/etc/my.cnf<<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    basedir = /usr/local/mysql
    datadir = /home/mysql/data
    pid-file = /home/mysql/data/mysql.pid
    log-error = /home/mysql/data/error.log
    user = mysql
    skip-external-locking
    key_buffer_size = 16M
    max_allowed_packet = 1M
    table_open_cache = 256
    sort_buffer_size = 512K
    net_buffer_length = 8K
    read_buffer_size = 256K
    read_rnd_buffer_size = 512K
    myisam_sort_buffer_size = 8M
    thread_cache_size = 8
    query_cache_size = 8M
    tmp_table_size = 16M
    performance_schema_max_table_instances = 500
    explicit_defaults_for_timestamp = true
    max_connections = 500
    max_connect_errors = 100
    open_files_limit = 65535
    table_definition_cache = 400
    log-bin=mysql-bin
    binlog_format=mixed
    server-id   = 1
    expire_logs_days = 10

    default_storage_engine = InnoDB

    [mysqldump]
    quick
    max_allowed_packet = 16M

    [mysql]
    no-auto-rehash

    [myisamchk]
    key_buffer_size = 20M
    sort_buffer_size = 20M
    read_buffer = 2M
    write_buffer = 2M

    [mysqlhotcopy]
    interactive-timeout
EOF
    # 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /etc/my.cnf
    /usr/local/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/home/mysql/data;
    chmod 775 /usr/local/mysql/support-files/mysql.server;
    /usr/local/mysql/support-files/mysql.server start;
    # /usr/local/mysql/bin/mysqladmin password ${MysqlPass}
    ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql;
    ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin;
    ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump;
    ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk;
    ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe;
    rm -rf /usr/local/mysql/data/test;
    if grep "release 6.*" /etc/*-release | grep -Eqi "CentOS" ; then
        cp /usr/local/mysql/support-files/mysql.server /etc/rc.d/init.d/mysql;
        chkconfig mysql on;
    else
cat >>/lib/systemd/system/mysql.service<<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
    # 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
    fi;
    ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql;
    systemctl daemon-reload;
    systemctl enable mysql;
    yellow "[OK] mysql-${mysql_ver} install completed.";
}

if [ $(command -v mysql) ]; then
    yellow "mysql-${mysql_ver}已安装,安装目录“/usr/local/mysql”，程序名“mysql”"
else
    KeyTips="安装已编译好的“mysql-${mysql_ver}”" && ShowColorTipsB
    install_mysql_56
fi