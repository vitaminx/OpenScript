#!/bin/bash
color_yellow='\033[0;32m'
color_end='\033[0m'

###################### 基 础 函 数 ######################
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
    # 检测函数（命令执行是否成功/软件是否安装/......）
    yes_or_no() {
        #上一条指令执行结果判断
        # 使用本函数必须配置三个变量“run_comd” “success_info” “failed_info”
        #run_comd="rclone" && success_info="设置成功" && failed_info="设置失败，请稍后手动修改配置文件"
        if [ $? -eq 0 ]; then
            echo -e "${color_yellow}“${run_comd}”${success_info}......${color_end}"
        else
            echo -e "${color_yellow}“${run_comd}”${failed_info}......${color_end}"
        fi
        ShowColorDottedLine
        run_comd=""
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
    # 系统配置
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
        elif [[ "$os" = "mac" ]]; then
            echo -e "\n${color_yellow}★★★★★ 您的操作系统为MacOS，请在图形界面手动安装 ★★★★★${color_end}" && exit
        else
            echo -e "\n${color_yellow} unknow os $OS, exit!${color_end}" && exit
        fi
    }
########################################################
# b9-安装caddy2
# 为了让nginx和caddy2能够共存，改caddy2监听端口为81和444

install_caddy2(){
    if [ -z "$(command -v caddy)" ]; then
        if [[ "$os" =~ "Ubuntu" ]] || [[ "$os" =~ "Debian" ]]; then
            KeyTips="开始安装“caddy2”及其依赖" && ShowColorTipsB
            ${cmd_install} install -y debian-keyring debian-archive-keyring apt-transport-https
            curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc
            curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
            ${cmd_install} update --fix-missing
            ${cmd_install} install -y caddy
            #修改caddy2监听端口为81和444
            sed -i '/:80 {/i\{' /etc/caddy/Caddyfile
            sed -i '/:80 {/i\    http_port 81' /etc/caddy/Caddyfile
            sed -i '/:80 {/i\    https_port 444' /etc/caddy/Caddyfile
            sed -i '/:80 {/i\}' /etc/caddy/Caddyfile
            sed -i '/:80 {/i\ ' /etc/caddy/Caddyfile
            sed -i 's/:80 {/:81 {/g' /etc/caddy/Caddyfile

        elif [[ "$os" =~ "CentOS" ]]; then
            os_num=$(cat /etc/redhat-release |cut -d" " -f4 |cut -d"." -f1)
            if [[ ${os_num} -le 7 ]];then
                yum install yum-plugin-copr
                yum copr enable @caddy/caddy
                yum install caddy
            elif [[ ${os_num} -ge 8 ]];then
                dnf install 'dnf-command(copr)'
                dnf copr enable @caddy/caddy
                dnf install caddy
            fi
        fi
        if [ $? -eq 0 ]; then
            systemctl enable caddy.service
            systemctl start caddy.service
            KeyTips="“caddy2”及其依赖安装成功" && ShowColorTipsA
        else
            KeyTips="“caddy2”及其依赖安装失败，请稍后手动安装" && ShowColorTipsA
        fi
    else    
        KeyTips="“caddy2”已安装" && ShowColorTipsA
    fi
    ShowColorDottedLine && echo -e
    cd ~ || exit
}

os_identification
os_variable
if $(command -v caddy &>/dev/null); then
    confirm_num=1
    read -n 1 -p """“caddy2”已安装，卸载重装请按“y”，按其他任意键跳过......""" confirm_num && echo -e
    if [[ ${confirm_num} == "y" ]]; then
        KeyTips="开始卸载“caddy2”" && ShowColorTipsB
        systemctl disable caddy
        systemctl stop caddy
        rm -f /etc/apt/sources.list.d/caddy-stable.list
        ${cmd_install} remove caddy -y
        if [ $? -eq 0 ]; then
            KeyTips="“caddy2”成功卸载，即将重新安装" && ShowColorTipsA
            install_caddy2
        else
            KeyTips="“caddy2”卸载失败，请稍后手动卸载后再安装" && ShowColorTipsA
        fi
    fi
else
    install_caddy2
fi

