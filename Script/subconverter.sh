#!/bin/bash
color_yellow='\033[0;32m'
color_end='\033[0m'

# 订阅转换后端“subconverter”项目版本号，查询网址：https://github.com/tindy2013/subconverter/releases
V_N_SubConverter="v0.7.2"
# “MyUrls短链服务”项目版本号，查询网址：https://github.com/CareyWang/MyUrls/releases
V_N_MyUrls="v1.10"

# 订阅转换器:Sub-web前台+SubConverter后端(域名在CF上开代理，域名走ssl)
    #domain_suc/domain_sub/domain_myurls需要解析到安装项目的vps的ip上并且打开代理，主域名“SSL/TLS 加密模式为 完全”
suc_api_access_token="123456abc"  #后端密码，随便设置
sub_tg="oneking"                  #订阅转换网站前端链接的tg账号名
github_user_name="vitaminx"      #github用户名，设置“sub-web-modify”库所在的位置

#======================= 基础函数 ======================
    # 输出彩色单虚线
    ShowColorDottedLine(){
        echo -e "${color_yellow}------------------------------------------------${color_end}"
    }
    # 输出彩色提示信息(必须定义变量)
    ShowColorTipsA(){
        echo -e "${color_yellow}${KeyTips}${color_end}"
    }
    # 输出彩色提示信息......(必须定义变量)
    ShowColorTipsB(){
        echo -e "${color_yellow}${KeyTips}......${color_end}"
    }
    # 操作系统识别
    os_identification(){
        osnamea="$(uname -a 2>/dev/null)"
        osnameb="$(cat /proc/version 2>/dev/null)"
        osnamec="$(lsb_release -a 2>/dev/null)"
        if [ -f "/etc/redhat-release" ]; then
            if [[ $(cat /etc/redhat-release) =~ "CentOS" ]]; then
                os="CentOS"
            fi
        elif [[ "$osnamea" =~ "Ubuntu" ]] || [[ "$osnamec" =~ "Ubuntu" ]] || [[ "$osnameb" =~ "Ubuntu" ]]; then
            os="Ubuntu"
        elif [[ "$osnamea" =~ "Debian" ]] || [[ "$osnamec" =~ "Debian" ]] || [[ "$osnameb" =~ "Debian" ]]; then
            os="Debian"
        elif [[ "$osnamea" =~ "CentOS" ]] || [[ "$osnamec" =~ "CentOS" ]] || [[ "$osnameb" =~ "CentOS" ]]; then
            os="CentOS"
        elif [[ "$osnamea" =~ "Darwin" ]] || [[ "$osnamec" =~ "Darwin" ]] || [[ "$osnameb" =~ "Darwin" ]]; then
            os="mac" && TitleiInformation="您的操作系统为MacOS，请在图形界面手动安装" && ShowColorPentagramTitle && exit
        else
            os="$osnameb"
            echo -e "\n${color_yellow} 操作系统无法识别, 结束本脚本!${color_end}\n" && exit
        fi
    }
    # 系统配置（根据不同的操作系统个性化软件配置）
    os_variable(){
        if [[ "$os" = "Debian" ]]; then
            cmd_install="apt-get"                                     #安装命令
            cmd_install_rely="build-essential"                        #c++编译环境
        elif [[ "$os" = "Ubuntu" ]]; then
            cmd_install="sudo apt-get"
            cmd_install_rely="build-essential"
        elif [[ "$os" = "CentOS" ]]; then
            cmd_install="yum"
            cmd_install_rely="gcc-c++ make"
        fi
    }
    # 安装软件
    softs_install(){
        #选择安装模式1或者2,默认1；和“需要安装的软件 insofts=()”
        #  installmod_num=1
        #  insofts=()
        #模式二安装表达式“installmod”和检查服务名“run_comd”
        #  installmod=""
        #  run_comd=""
        for ((aloop = 0; aloop < ${#insofts[@]}; aloop++)); do
            if `rpm -q ${insofts[$aloop]} &>/dev/null` || `dpkg -l ${insofts[$aloop]} &>/dev/null` || `which ${insofts[$aloop]} &>/dev/null`; then
                KeyTips="“${insofts[$aloop]}”已安装" && ShowColorTipsB
            else
                if [ ${insofts[$aloop]} = "update" ]; then
                    KeyTips="开始更新软件包数据库" && ShowColorTipsB
                    ${cmd_install} ${insofts[$aloop]} -y
                    if [ $? -eq 0 ]; then
                        KeyTips="软件包数据库更新成功" && ShowColorTipsB
                    else
                        KeyTips="软件包数据库更新失败，请稍后手动更新" && ShowColorTipsB
                    fi
                    ShowColorDottedLine
                elif [ ${insofts[$aloop]} = "upgrade" ]; then
                    KeyTips="开始更新系统" && ShowColorTipsB
                    ${cmd_install} ${insofts[$aloop]} -y
                    if [ $? -eq 0 ]; then
                        KeyTips="系统更新成功" && ShowColorTipsB
                    else
                        KeyTips="系统更新失败，请稍后手动更新" && ShowColorTipsB
                    fi
                    ShowColorDottedLine
                else
                    KeyTips="“${insofts[$aloop]}”开始安装" && ShowColorTipsB
                    if [[ ${installmod_num} == "1" ]]; then
                        ${cmd_install} install ${insofts[$aloop]} -y
                        if [ $? -eq 0 ]; then
                            KeyTips="“${insofts[$aloop]}”安装成功" && ShowColorTipsB
                        else
                            KeyTips="“${insofts[$aloop]}”安装失败，请稍后手动安装" && ShowColorTipsB
                        fi
                    elif [[ ${installmod_num} == "2" ]]; then
                        ${installmod}
                        if `which ${run_comd} &>/dev/null`; then
                            KeyTips="“${run_comd}”安装成功" && ShowColorTipsB
                        else
                            KeyTips="“${run_comd}”安装失败，请稍后手动安装" && ShowColorTipsB
                        fi
                    fi
                    ShowColorDottedLine
                fi
            fi
        done
        cd ~
    }
#======================================================
# 域名输入
info_input(){
    read -p """请输入“订阅转换项目”前端域名（即“访问域名”，可以是一级域名或二级域名）
    Input Your Sub Domain =>:""" domain_sub && echo -e

    read -p """请输入“订阅转换项目”后端域名（即“数据处理域名”，建议“suc.一级域名”）
    Input Your Suc Domain =>:""" domain_suc && echo -e

    # 输入"MyUrls短链服务"域名
    read -p """请输入“MyUrls短链服务”域名（即“短链接域名”、建议尽可能短）
    Input Your Top MyUrls Domain =>:""" domain_myurls && echo -e

    # 输入"订阅转换站点名"
    read -p """请输入“订阅转换项目”站点名（文字间空格隔开，中文字符空格隔开，如：“老 刘”、“LaoLiu”）
    Input Your SubConverter Site Name =>:""" sub_site_name && echo -e
    #设置“短连接名”：为“订阅转换站点名”去掉变量里所有空格（“老 刘”变为“老刘”）
    sub_site_name_1="$(echo ${sub_site_name// /})"

    read -p """请设置“后端密码”（可以随便设置，如“123456abc”）
    Input Your Suc Api Access Token =>:""" suc_api_access_token && echo -e

    read -p """请输入“订阅转换网站前端链接的tg账号名”（你自己的tg注册账号，如：onekings）
    Input Your TG Account =>:""" sub_tg && echo -e

    read -p """请输入“订阅转换网站前端链接的github账户”（点击跳转到你的github上的sub项目，如：vitaminx）
    Input Your TG Account =>:""" github_user_name && echo -e

}

# b11-订阅转换器:Sub-web前端搭建
caddy_sub(){
  # 卸载sub-web-modify
    if $(ls /home | grep "sub-web-modify" &>/dev/null); then
        KeyTips="卸载清理已安装“sub-web-modify”项目" && ShowColorTipsB
        rm -rf /home/sub-web-modify &>/dev/null
        rm -rf /var/www/html &>/dev/null
    fi
  # 项目必须安装依赖：nodejs、npm、yarn，nodejs和npm系统安装
    cd ~
    if [ -z "$(command -v node)" ]; then
        KeyTips="开始安装依赖：nodejs" && ShowColorTipsB
        ${cmd_install} install -y nodejs
        if [ $? -eq 0 ]; then
            KeyTips="“nodejs”安装成功" && ShowColorTipsB
        else
            KeyTips="“nodejs”安装失败，请稍后手动安装" && ShowColorTipsB
        fi
    fi
    if [ -z "$(command -v npm)" ]; then
        KeyTips="开始安装依赖：npm" && ShowColorTipsB
        ${cmd_install} install -y npm
        if [ $? -eq 0 ]; then
            KeyTips="“npm”安装成功" && ShowColorTipsB
        else
            KeyTips="“npm”安装失败，请稍后手动安装" && ShowColorTipsB
        fi
    fi
    if [ -z "$(command -v yarn)" ]; then
        KeyTips="开始安装依赖：yarn" && ShowColorTipsB
        npm install -g yarn
        if [ $? -eq 0 ]; then
            KeyTips="“yarn”安装成功" && ShowColorTipsB
        else
            KeyTips="“yarn”安装失败，请稍后手动安装" && ShowColorTipsB
        fi
    fi

  #停止SubConverter后端
    systemctl stop sub.service
  #下载安装sub-web-modify项目
    KeyTips="下载“sub-web-modify”项目代码" && ShowColorTipsB
    cd /home && git clone https://github.com/vitaminx/sub-web-modify.git && chmod -R 755 sub-web-modify && chown -R caddy.caddy sub-web-modify

  #修改文件Subconverter.vue
    KeyTips="项目“sub-web-modify”个性化，修改“Subconverter.vue”文件" && ShowColorTipsB
    # 设置“订阅转换”项目名，也是网址显示名
    sed -i "s%style=\"text-align:center;font-size:15px\">.* 订 阅 转 换<\/div>%style=\"text-align:center;font-size:15px\">${sub_site_name} 订 阅 转 换<\/div>%g" /home/sub-web-modify/src/views/Subconverter.vue
    # 短连接名+网址
    sed -i "s%\".*短链接\":\"https://.*/short\"%\"${sub_site_name_1}短链接\":\"https://${domain_myurls}/short\"%g" /home/sub-web-modify/src/views/Subconverter.vue
    # sub后端名+网址
    sed -i "s%\".*后端\": \"https://.*/sub%\"${sub_site_name_1}后端\": \"https://${domain_suc}/sub%g" /home/sub-web-modify/src/views/Subconverter.vue
    # value值“后端网址”
    sed -i "s%value: \"https://suc.*/sub%value: \"https://${domain_suc}/sub%g" /home/sub-web-modify/src/views/Subconverter.vue
    # customBackend值“后端网址”
    sed -i "s%customBackend: \"https://.*/sub%customBackend: \"https://${domain_suc}/sub%g" /home/sub-web-modify/src/views/Subconverter.vue
    # shortType短连接值“短连接网址”
    sed -i "s%shortType: \"https://.*/short\"%shortType: \"https://${domain_myurls}/short\"%g" /home/sub-web-modify/src/views/Subconverter.vue
  #修改文件“.env”
    KeyTips="项目“sub-web-modify”个性化，修改“.env”文件" && ShowColorTipsB
    # github上项目地址
    sed -i "s%VUE_APP_PROJECT = \"https://github.com/.*/sub-web-modify\"%VUE_APP_PROJECT = \"https://github.com/${github_user_name}/sub-web-modify\"%g" /home/sub-web-modify/.env
    # 订阅转换网站前端链接的tg账号名
    sed -i "s%VUE_APP_BOT_LINK = \"https://t.me/.*\"%VUE_APP_BOT_LINK = \"https://t.me/${sub_tg}\"%g" /home/sub-web-modify/.env
    # API 后端
    sed -i "s%VUE_APP_SUBCONVERTER_DEFAULT_BACKEND = \"https://.*\"%VUE_APP_SUBCONVERTER_DEFAULT_BACKEND = \"https://${domain_suc}\"%g" /home/sub-web-modify/.env
    # 短链接后端网址
    sed -i "s%VUE_APP_MYURLS_DEFAULT_BACKEND = \"https://.*\"%VUE_APP_SUBCONVERTER_DEFAULT_BACKEND = \"https://${domain_myurls}\"%g" /home/sub-web-modify/.env

  #yarn安装sub-web-modify项目
    KeyTips="yarn安装“sub-web-modify”项目" && ShowColorTipsB
    cd /home/sub-web-modify
    #yarn config set ignore-engines true
    yarn install --network-timeout 600000
  #yarn打包sub-web-modify项目
    KeyTips="yarn打包“sub-web-modify”项目" && ShowColorTipsB
    cd /home/sub-web-modify
    #npm install autoprefixer@latest caniuse-lite@latest browserslist@latest --save-dev
    #npm i caniuse-lite browserslist
    yarn build && chown -R caddy.caddy /home/sub-web-modify

  #caddy发布
    KeyTips="caddy发布“sub-web-modify”项目" && ShowColorTipsB
    mkdir -p /var/www/html && cp -r /home/sub-web-modify/dist/* /var/www/html && chmod -R 755 /var/www/html/ && chown -R caddy.caddy /var/www/html

  # 配置caddy2反代
    if $(cat /etc/caddy/Caddyfile | grep "${domain_sub}" &>/dev/null); then
        KeyTips="“${domain_sub}”已设置反代，请检查是否正确" && ShowColorTipsB
    else
        KeyTips="caddy设置“${domain_sub}”反代" && ShowColorTipsB
        echo "" >>/etc/caddy/Caddyfile
        echo "${domain_sub} {" >>/etc/caddy/Caddyfile
        echo "    encode gzip" >>/etc/caddy/Caddyfile
        echo "    root * /home/sub-web-modify/dist" >>/etc/caddy/Caddyfile
        echo "    file_server" >>/etc/caddy/Caddyfile
        echo "}" >>/etc/caddy/Caddyfile
    fi

  # 启动SubConverter后端
    systemctl start sub.service

  # caddy重启
    systemctl reload caddy
    systemctl stop caddy.service
    systemctl start caddy.service
    ShowColorDottedLine
    cd ~ || exit
}

# b10-订阅转换器:SubConverter后端搭建
caddy_suc(){
    # 卸载subconverter后端
    if $(ls /home | grep "subconverter" &>/dev/null); then
        KeyTips="卸载清理已安装“SubConverter后端”项目" && ShowColorTipsB
        systemctl stop sub.service &>/dev/null
        systemctl stop subconverter.service &>/dev/null
        rm -rf /etc/systemd/system/sub.service &>/dev/null
        rm -rf /etc/systemd/system/subconverter.service &>/dev/null
        rm -rf /home/subconverter &>/dev/null
        rm -rf /home/subconverter_linux64*
    fi
    KeyTips="下载“SubConverter后端”程序并解压" && ShowColorTipsB
    #下载并解压后端程序
    cd /home && wget https://github.com/tindy2013/subconverter/releases/download/${V_N_SubConverter}/subconverter_linux64.tar.gz && tar -zxf subconverter_linux64.tar.gz && rm -rf /home/subconverter_linux64*

    # 修改配置文件参数
    KeyTips="修改配置文件“pref.ini”" && ShowColorTipsB
    if $(ls /home/subconverter | grep "pref.example.ini" &>/dev/null); then
        cp -r /home/subconverter/pref.example.ini /home/subconverter/pref.ini
    fi
    sed -i "s%api_access_token=.*%api_access_token=${suc_api_access_token}%g" /home/subconverter/pref.ini
    sed -i "s%managed_config_prefix=.*%managed_config_prefix=https://${domain_suc}%g" /home/subconverter/pref.ini
    sed -i "s%listen=.*%listen=127.0.0.1%g" /home/subconverter/pref.ini

    # 创建服务进程并启动
    KeyTips="创建服务进程“sub.service”" && ShowColorTipsB
    systemctl stop sub.service &>/dev/null
    systemctl stop subconverter.service &>/dev/null
    rm -rf /etc/systemd/system/sub.service &>/dev/null
    rm -rf /etc/systemd/system/subconverter.service &>/dev/null
    echo "[Unit]" >/etc/systemd/system/sub.service
    echo "Description=A API For Subscription Convert" >>/etc/systemd/system/sub.service
    echo "After=network.target" >>/etc/systemd/system/sub.service
    echo "" >>/etc/systemd/system/sub.service
    echo "[Service]" >>/etc/systemd/system/sub.service
    echo "Type=simple" >>/etc/systemd/system/sub.service
    echo "ExecStart=/home/subconverter/subconverter" >>/etc/systemd/system/sub.service
    echo "WorkingDirectory=/home/subconverter" >>/etc/systemd/system/sub.service
    echo "Restart=always" >>/etc/systemd/system/sub.service
    echo "RestartSec=10" >>/etc/systemd/system/sub.service
    echo "" >>/etc/systemd/system/sub.service
    echo "[Install]" >>/etc/systemd/system/sub.service
    echo "WantedBy=multi-user.target" >>/etc/systemd/system/sub.service

    # 载入参数设置设置开机自启
    systemctl daemon-reload && systemctl enable sub && systemctl start sub
    # 检测subconverter后端是否安装成功，如安装成功则进行后续caddy反代设置
    if [ $? -eq 0 ]; then
        KeyTips="“SubConverter后端”部署成功" && ShowColorTipsA
        # 检测caddy是否安装
        if $(command -v caddy &>/dev/null); then
            echo -e "caddy已安装"
        else
            bash <(curl -sL fto.cc/caddy)
        fi
        # 配置caddy2反代
        if $(cat /etc/caddy/Caddyfile | grep "${domain_suc}" &>/dev/null); then
            KeyTips="“${domain_suc}”反代已设置，请检查是否正确" && ShowColorTipsB
        else
            KeyTips="caddy设置“${domain_suc}”反代" && ShowColorTipsB
            echo "" >>/etc/caddy/Caddyfile
            echo "${domain_suc} {" >>/etc/caddy/Caddyfile
            echo "    encode gzip" >>/etc/caddy/Caddyfile
            echo "    file_server" >>/etc/caddy/Caddyfile
            echo "    reverse_proxy localhost:25500" >>/etc/caddy/Caddyfile
            echo "}" >>/etc/caddy/Caddyfile
        fi
        # caddy重启
        systemctl reload caddy
        systemctl stop caddy.service
        systemctl start caddy.service
        if [ $? -eq 0 ]; then
            KeyTips="“SubConverter后端”配置caddy2反代成功，请在浏览器输入“https://${domain_suc}/version”测试" && ShowColorTipsA
        else
            KeyTips="“SubConverter后端”配置caddy2反代失败，请手动配置" && ShowColorTipsB
        fi
    else
        KeyTips="“SubConverter后端”安装失败，请稍后手动安装，并用caddy设置反代" && ShowColorTipsB
    fi
    ShowColorDottedLine
    cd ~ || exit
}

# b12-MyUrls短链服务
caddy_MyUrls(){
    #说明：本项目必须安装“caddy”
  #卸载“MyUrls短链服务”
    if $(ls /home | grep "myurls" &>/dev/null); then
        KeyTips="卸载清理已安装“MyUrls短链服务”项目" && ShowColorTipsB
        rm -rf /home/myurls &>/dev/null
        rm -rf /etc/systemd/system/myurls.service &>/dev/null
    fi
  #安装依赖Redis服务，本服务依赖于 Redis 提供长短链接映射关系存储，你需要本地安装 Redis 服务来保证短链接服务的正常运行
    local insofts=(redis-server)
    softs_install
  #下载项目代码
    KeyTips="下载“MyUrls短链服务”项目代码并解压" && ShowColorTipsB
    wget -q https://github.com/CareyWang/MyUrls/releases/download/${V_N_MyUrls}/linux-amd64.tar.gz -O /home/myurls.tar --no-check-certificate
    tar -xvf /home/myurls.tar -C /home && rm -f /home/myurls.tar
    chmod -R 755 /home/myurls && chown -R caddy.caddy /home/myurls
  #编辑/home/myurls/public/index.html文件，将const backend这里改成自己的域名
    KeyTips="修改“MyUrls短链服务”项目域名" && ShowColorTipsB
    sed -i "s%^    const backend .*%    const backend = \'https://${domain_myurls}\'%g" /home/myurls/public/index.html
  #新建文件 /etc/systemd/system/myurls.service，写入内容然后保存：（ExecStart 、WorkingDirectory两个参数后面的路径改成自己的网站根目录，以及将 example.com 替换为自己的网址）
    KeyTips="创建启动文件“myurls.service”" && ShowColorTipsB
    echo "[Unit]" >/etc/systemd/system/myurls.service
    echo "Description=A API For Short URL Convert" >>/etc/systemd/system/myurls.service
    echo "After=network.target" >>/etc/systemd/system/myurls.service
    echo "" >>/etc/systemd/system/myurls.service
    echo "[Service]" >>/etc/systemd/system/myurls.service
    echo "Type=simple" >>/etc/systemd/system/myurls.service
    echo "ExecStart=/home/myurls/linux-amd64-myurls.service -domain ${domain_myurls}" >>/etc/systemd/system/myurls.service
    echo "WorkingDirectory=/home/myurls" >>/etc/systemd/system/myurls.service
    echo "Restart=always" >>/etc/systemd/system/myurls.service
    echo "RestartSec=10" >>/etc/systemd/system/myurls.service
    echo "" >>/etc/systemd/system/myurls.service
    echo "[Install]" >>/etc/systemd/system/myurls.service
    echo "WantedBy=multi-user.target" >>/etc/systemd/system/myurls.service
  #启动和设置开启启动后端服务
    systemctl daemon-reload && systemctl enable myurls && systemctl start myurls
    if [ $? -eq 0 ]; then
        KeyTips="“MyUrls短链服务”部署成功" && ShowColorTipsA
      #配置caddy反代
        if $(cat /etc/caddy/Caddyfile | grep "${domain_myurls}" &>/dev/null); then
            KeyTips="“${domain_myurls}”已设置反代，请在浏览器输入网址“${domain_myurls}”测试" && ShowColorTipsB
        else
            KeyTips="caddy设置“${domain_myurls}”反代" && ShowColorTipsB
            echo "" >>/etc/caddy/Caddyfile
            echo "${domain_myurls} {" >>/etc/caddy/Caddyfile
            echo "    encode gzip" >>/etc/caddy/Caddyfile
            echo "    root * /home/myurls/public" >>/etc/caddy/Caddyfile
            echo "    file_server" >>/etc/caddy/Caddyfile
            echo "    reverse_proxy localhost:8002" >>/etc/caddy/Caddyfile
            echo "    header Access-Control-Allow-Origin *" >>/etc/caddy/Caddyfile
            echo "}" >>/etc/caddy/Caddyfile
          #重启caddy
            systemctl reload caddy
            if [ $? -eq 0 ]; then
                KeyTips="“MyUrls短链服务”caddy反代设置成功，请在浏览器输入网址“${domain_myurls}”使用测试" && ShowColorTipsA
            else
                KeyTips="“MyUrls短链服务”caddy反代设置失败，请稍后找出问题，再手动设置" && ShowColorTipsB
            fi
        fi
    else
        KeyTips="“MyUrls短链服务”部署失败，请稍后找出问题，再手动部署" && ShowColorTipsB
    fi
    ShowColorDottedLine
    cd ~ || exit
}

#屏幕显示
debian_info_screen(){
    echo -e && echo -e "${color_yellow}本次部署的“订阅转换项目”参数如下：${color_end}"
    echo -e "    1. 订阅转换站点名：${sub_site_name} 订 阅 转 换"
    echo -e "    ${color_yellow}2. 订阅转换站点访问地址：${domain_sub}${color_end}"
    echo -e "    3. 订阅转换后端名：${sub_site_name_1}后端"
    echo -e "    ${color_yellow}4. 订阅转换后端访问地址：${domain_suc}/version${color_end}"
    echo -e "    5. MyUrls短链服务名：${sub_site_name_1}短连接"
    echo -e "    ${color_yellow}6. MyUrls短链服务访问地址：${domain_myurls}${color_end}" && echo -e
}

info_input   #信息输入
vps_ip="$(curl -s cip.cc |grep "IP" |cut -d":" -f2 |cut -d" " -f2)"
echo -e && echo -e "${color_yellow}“订阅转换”项目部署前期准备：${color_end}
    1. 域名“${domain_suc}/${domain_sub}/${domain_myurls}”解析到服务器“${vps_ip}”
    ${color_yellow}2. 服务器开放端口“25500”${color_end}" && echo -e

read -n 1 -p """确认已完成以上2步，请按“y”执行本次任务，按其他任意键终止执行本次任务......""" subconverter_num && echo -e
if [[ ${subconverter_num} == "y" ]]; then
    os_identification
    os_variable
    
    if [ -z "$(which caddy)" ]; then
        if [ $(which nginx) ]; then
            KeyTips="系统已安装“nginx”，本脚本针对caddy部署，请卸载“nginx”后运行脚本或者手动安装" && ShowColorTipsB && exit
        else
            bash <(curl -sL fto.cc/caddy)
        fi
    fi

    caddy_suc           #订阅转换器:SubConverter后端搭建
    caddy_sub           #订阅转换器:Sub-web前端搭建
    caddy_MyUrls        #MyUrls短链服务
    debian_info_screen
fi
