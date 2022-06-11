#!/bin/bash
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

function install_php_rely(){
    # 安装依赖
    KeyTips="安装“PHP编译”所需依赖" && ShowColorTipsB
    apt -y install apt-utils
    apt -y install autoconf
    apt -y install gcc
    apt -y install make
    apt -y install openssl
    apt -y install curl
    apt -y install bison
    apt -y install re2c
    apt -y install pkg-config
    apt -y install libxml2-dev
    apt -y install libbz2-dev
    apt -y install libjpeg-dev
    apt -y install libpng-dev
    apt -y install libfreetype6-dev
    apt -y install libzip-dev
    apt -y install build-essential
    apt -y install libssl-dev
    apt -y install libcurl4-openssl-dev
    apt -y install libpng12-dev
    apt -y install libgmp-dev
    apt -y install libreadline6-dev
    apt -y install libxslt1-dev
    apt -y install libsqlite3-dev
    apt -y install libonig-dev
    apt -y install librecode-dev
    apt -y install libreadline-dev
    apt -y install libmysqlclient-dev
    apt -y install libjpeg8-dev
    apt -y install libmcrypt-dev
    apt -y install libenchant-dev
    apt -y install libpspell-dev
    apt -y install libicu-dev
    apt -y install libltdl-dev
}
function CheckSystem() {
    Cpunum=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
    RamTotal=$(free -m | grep 'Mem' | awk '{print $2}')
    RamSwap=$(free -m | grep 'Swap' | awk '{print $2}')
    if [ ! -n "RamSwap" ]; then
        Ramzh=$(expr ${RamTotal} + ${RamSwap})
    else
        Ramzh=${RamTotal}
    fi
    swapoff -a
    dd if=/dev/zero of=/swapfile bs=1M count=1200
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile       swap    swap defaults   0 0" >>/etc/fstab
    Cpunum=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
    RamTotal=$(free -m | grep 'Mem' | awk '{print $2}')
    RamSwap=$(free -m | grep 'Swap' | awk '{print $2}')
    Ramzh=$(expr ${RamTotal} + ${RamSwap})
    echo ${RamTotal} ${RamSwap} ${Ramzh}
    if [ "${Ramzh}" -ge 1100 ]; then
        fileinfo=--enable-fileinfo
    else
        fileinfo=--disable-fileinfo
    fi
    echo "${SysBit}Bit, ${Cpunum}*CPU, ${RamTotal}MB*RAM, ${RamSwap}MB*Swap"
}
function InstallPhp81() {
    php_ver="8.1.7"
    apcu_ver="5.1.21"

    #安装依赖
    install_php_rely

    wget https://www.php.net/distributions/php-${php_ver}.tar.gz
    tar -zxf php-${php_ver}.tar.gz
    cd php-${php_ver}
    ./configure --prefix=/usr/local/php/php81 --with-config-file-path=/usr/local/php/php81/etc --enable-fpm --with-fpm-user=caddy --with-fpm-group=caddy --enable-mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv --with-zlib --with-libxml --enable-xml --with-freetype=/usr/local/freetype --enable-bcmath --enable-shmop --with-jpeg --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-mbstring --enable-ftp --enable-gd --with-openssl=/usr/local/openssl11 --enable-pcntl --enable-sockets --with-xmlrpc --with-zip --enable-soap --with-pear --with-gettext --enable-calendar $fileinfo --with-bz2 --with-readline --enable-sysvshm --enable-sysvmsg --enable-bcmath --enable-mbstring --with-gettext --enable-shared --enable-inline-optimization --disable-debug --disable-rpath --enable-opcache
    make -j$Cpunum && make install
    cp php.ini-development /usr/local/php/php81/etc/php.ini
    sed -i 's/disable_functions =/disable_functions=eval,passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,disk_total_space,disk_free_space,error_log,putenv,popen,ini_set,chmod,assert,pcntl_exec,phpfunc;/' /usr/local/php/php81/etc/php.ini
    rm -rf /usr/local/php/php81/etc/php-fpm.conf
cat >>/usr/local/php/php81/etc/php-fpm.conf <<EOF
    [global]
    pid = /usr/local/php/php81/tmp/php-fpm.pid
    error_log = /usr/local/php/php81/tmp/php-fpm.log
    log_level = notice

    [www]
    user = caddy
    group = caddy
    listen.owner = caddy
    listen.group = caddy
    listen = /usr/local/php/php81/tmp/php-cgi.sock
    listen.backlog = -1
    listen.allowed_clients = 127.0.0.1
    listen.mode = 0666
    pm = dynamic
    pm.max_children = 20
    pm.start_servers = 4
    pm.min_spare_servers = 2
    pm.max_spare_servers = 15
    pm.max_requests = 1000
    pm.process_idle_timeout = 10s
    request_terminate_timeout = 150
    request_slowlog_timeout = 0
    rlimit_files = 51200
    slowlog = /usr/local/php/php81/tmp/slow.log
EOF
    # 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /usr/local/php/php81/etc/php-fpm.conf
    mkdir -p /usr/local/php/php81/tmp
    chown -R caddy:caddy /usr/local/php/php81/tmp
    sed -i 's/post_max_size/;post_max_size/' /usr/local/php/php81/etc/php.ini
    echo 'post_max_size=100M' >>/usr/local/php/php81/etc/php.ini
    sed -i 's/upload_max_filesize/;upload_max_filesize/' /usr/local/php/php81/etc/php.ini
    echo 'upload_max_filesize=100M' >>/usr/local/php/php81/etc/php.ini
    sed -i 's/max_execution_time/;max_execution_time/' /usr/local/php/php81/etc/php.ini
    sed -i 's/;cgi.fix_pathinfo=.*/cgi.fix_pathinfo=0/g' /usr/local/php/php81/etc/php.ini
    sed -i 's/;date.timezone =.*/date.timezone = PRC/g' /usr/local/php/php81/etc/php.ini
    sed -i 's/short_open_tag =.*/short_open_tag = On/g' /usr/local/php/php81/etc/php.ini
    sed -i 's/max_execution_time/;max_execution_time/' /usr/local/php/php81/etc/php.ini
    echo 'max_execution_time=300' >>/usr/local/php/php81/etc/php.ini
    cd .. && rm -rf php-${php_ver} php-${php_ver}.tar.gz
    #apcu
    wget https://pecl.php.net/get/apcu-${apcu_ver}.tgz
    tar zxf apcu-${apcu_ver}.tgz
    cd apcu-${apcu_ver}
    /usr/local/php/php81/bin/phpize
    ./configure --with-php-config=/usr/local/php/php81/bin/php-config
    make -j$Cpunum && make install
    echo 'extension="apcu.so"' >>/usr/local/php/php81/etc/php.ini
    echo 'zend_extension = opcache.so ' >>/usr/local/php/php81/etc/php.ini
    echo 'opcache.enable=1' >>/usr/local/php/php81/etc/php.ini
    echo 'opcache.memory_consumption = 128' >>/usr/local/php/php81/etc/php.ini
    echo 'opcache.interned_strings_buffer = 8' >>/usr/local/php/php81/etc/php.ini
    echo 'opcache.max_accelerated_files = 10000' >>/usr/local/php/php81/etc/php.ini
    echo 'opcache.revalidate_freq = 2' >>/usr/local/php/php81/etc/php.ini
    echo 'opcache.enable_cli = 1' >>/usr/local/php/php81/etc/php.ini
    cd .. && rm -rf apcu-${apcu_ver} apcu-${apcu_ver}.tgz
    rm -rf /lib/systemd/system/php-fpm81.service &>/dev/null
cat >>/lib/systemd/system/php-fpm81.service <<\EOF
    [Unit] 
    Description=The PHP FastCGI Process Manager 
    After=caddy.service 

    [Service]
    Type=forking
    PIDFile=/usr/local/php/php81/tmp/php-fpm.pid
    ExecStart=/usr/local/php/php81/sbin/php-fpm
    ExecReload=/bin/kill -USR2 $MAINPID
    PrivateTmp=true

    [Install] 
    WantedBy=multi-user.target
EOF
    # 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /lib/systemd/system/php-fpm81.service
    ln -s /lib/systemd/system/php-fpm81.service /etc/systemd/system/multi-user.target.wants/php-fpm81
    ln -s /usr/local/php/php81/bin/php /usr/bin/php81
    systemctl daemon-reload
    systemctl enable php-fpm81
}

if [ $(command -v php81) ]; then
    KeyTips="PHP81已安装,安装目录“/usr/local/php/php81”，程序名“php81”" && ShowColorTipsA
else
    KeyTips="硬件参数检测及缓存设置" && ShowColorTipsB
    CheckSystem
    ShowColorDoubleDottedLine
    KeyTips="编译安装“PHP-${php_ver}”" && ShowColorTipsB
    InstallPhp81
fi