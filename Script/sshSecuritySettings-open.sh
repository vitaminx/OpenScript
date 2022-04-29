#!/bin/bash
###################### 参 数 设 置 ######################
    # 颜色参数
    color_yellow='\033[0;32m'
    color_end='\033[0m'

    # 设置参数
    MyUserName="username"            #新建用户名
    MyUserKey='passwd'               #新建用户密码
    MyRootKey='rootpasswd'           #root用户密码
    SshPort="22"                     #ssh登录端口
    your_public_key="ssh-rsa"        #公钥

########################################################
    # 输出单虚线(内部分隔)
    ShowDottedLine(){
        echo -e "------------------------------------------------"
    }
    # 输出彩色五角星标题(必须定义变量)
    ShowColorPentagramTitle(){
        echo -e "${color_yellow}★★★★★ ${TitleiInformation} ★★★★★${color_end}"
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
    # 检测函数（命令执行是否成功/软件是否安装/......）
    yes_or_no() {
        #上一条指令执行结果判断
        # 用本函数必须配置三个变量“run_comd” “success_info” “failed_info”
        if [ $? -eq 0 ]; then
            echo -e "${color_yellow}${run_comd}${success_info}${color_end}"
        else
            echo -e "${color_yellow}${run_comd}${failed_info}${color_end}"
        fi
        run_comd=""
    }
########################################################
os_identification
input_new_user_name(){
    # 新建用户名
    read -p """请输入你需要新建的用户名并回车
    Input Your New User Name =>:""" MyUserName && echo -e
    KeyTips="将要新建的用户为“${MyUserName}”" && ShowColorTipsA && echo -e
}
input_new_user_passwd(){
    # 新建用户密码
    read -p """请输入新用户密码回车（以“ssh-rsa”开头）
    Input Your New User Passwd =>:""" MyUserKey && echo -e
    KeyTips="新用户密码为“${MyUserKey}”" && ShowColorTipsA && echo -e
}
input_root_passwd(){
    # root用户密码
    read -p """请输入修改的root用户密码并回车
    Input Your Root Passwd =>:""" MyRootKey && echo -e
    KeyTips="将要修改的Root用户密码为“${MyRootKey}”" && ShowColorTipsA && echo -e
}
input_ssh_port(){
    # ssh登录端口号
    read -p """请输入修改的ssh端口号并回车
    Input Your ssh Port =>:""" SshPort && echo -e
    KeyTips="将要修改的Root用户密码为“${SshPort}”" && ShowColorTipsA && echo -e
}
input_ssh_key(){
    # 输入公钥
    read -p """请输入你需要设置的公钥并回车（以“ssh-rsa”开头）
    Input Your Public Key =>:""" your_public_key && echo -e
    KeyTips="输入的公钥为“${your_public_key}”" && ShowColorTipsA && echo -e
}


# 删除原用户
del_old_user(){
    compgen -u >/home/compgen_file
    ls /home >/home/ls_home_file
    home_user_name=($(cat /home/ls_home_file /home/compgen_file | sort | uniq -d))
    rm -rf /home/compgen_file &>/dev/null
    rm -rf /home/ls_home_file &>/dev/null
    num=0
    while ((num <= ${#home_user_name[@]})); do
        KeyTips="删除“${home_user_name[num]}”用户" && ShowColorTipsB
        userdel -rf ${home_user_name[num]} &>/dev/null
        #sed -i '/${home_user_name[num]}/d' /etc/sudoers
        let "num += 1"
    done
}

# 创建新用户${MyUserName}
create_new_user(){
    if compgen -u | grep -q -E -i "${MyUserName}"; then
    read -n 1 -p """用户“${MyUserName}”已经存在，删除重建请输入“y”，按其他任意键终止执行脚本......
        请输入 =>:""" ssh_num && echo -e
    if [[ ${ssh_num} == "y" ]]; then
        read -n 1 -p """你选择删除用户“${MyUserName}”，请确保“ubuntu”用户文件夹下秘钥存在，请按“y”再次确认，按其他任意键退出......
        请输入 =>:""" ssh_num && echo -e
        if [[ ${ssh_num} == "y" ]]; then
            KeyTips="用户“${MyUserName}”已经存在，删除重建" && ShowColorTipsB
            userdel -rf useroneking &>/dev/null
        else
            KeyTips="用户“${MyUserName}”已经存在，退出脚本" && ShowColorTipsB && echo -e && exit
        fi
    else
        KeyTips="用户“${MyUserName}”已经存在，退出脚本" && ShowColorTipsB && echo -e && exit
    fi
    fi
    KeyTips="创建新用户“${MyUserName}”，并设置用户目录“/home/${MyUserName}”" && ShowColorTipsB
    run_comd="创建新用户“${MyUserName}”，并设置用户目录“/home/${MyUserName}”" && success_info="成功" && failed_info="失败，请稍后手动创建"
    useradd -d /home/${MyUserName} -m ${MyUserName}
    yes_or_no && ShowDottedLine
}

# 修改用户${MyUserName}密码为${MyUserKey}
create_new_user_passwd(){
    KeyTips="修改用户“${MyUserName}”密码为“${MyUserKey}”" && ShowColorTipsB
    if [[ "$os" =~ "Ubuntu" ]] || [[ "$os" =~ "Debian" ]]; then
        run_comd="修改用户“${MyUserName}”密码为“${MyUserKey}”" && success_info="成功" && failed_info="失败，请稍后手动修改"
        /bin/echo ${MyUserName}:"${MyUserKey}" |chpasswd
        yes_or_no

        KeyTips="本系统为“ubuntu”，修改“root”用户密码为“${MyRootKey}”" && ShowColorTipsB
        run_comd="修改用户“root”密码为“${MyRootKey}”" && success_info="成功" && failed_info="失败，请稍后手动修改"
        /bin/echo root:"${MyRootKey}" |chpasswd
        yes_or_no

    elif [[ "$os" =~ "CentOS" ]]; then
        run_comd="修改用户“${MyUserName}”密码为“${MyUserKey}”" && success_info="成功" && failed_info="失败，请稍后手动修改"
        echo "${MyUserKey}" | passwd --stdin ${MyUserName}
        yes_or_no

        KeyTips="本系统为“centos”，修改“root”用户密码为“${MyRootKey}”" && ShowColorTipsB
        run_comd="修改用户“root”密码为“${MyRootKey}”" && success_info="成功" && failed_info="失败，请稍后手动修改"
        echo "${MyRootKey}" | passwd --stdin root
        yes_or_no

    fi && ShowDottedLine
}

# 给${MyUserName}用户加上sudo权限
endow_user_sudo(){
    KeyTips="给“${MyUserName}”用户加上“sudo”权限" && ShowColorTipsB
    if cat /etc/sudoers | grep -q -E -i "${MyUserName}"; then
        run_comd="给“${MyUserName}”用户加上“sudo”权限" && success_info="成功" && failed_info="失败，请稍后手动修改"
        sed -i "/${MyUserName}/c ${MyUserName} ALL=(ALL) NOPASSWD: ALL" /etc/sudoers
        yes_or_no
    else
        run_comd="给“${MyUserName}”用户加上“sudo”权限" && success_info="成功" && failed_info="失败，请稍后手动修改"
        echo "${MyUserName} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
        yes_or_no
    fi && ShowDottedLine
}

# 设置登录秘钥
set_ssh_key(){
    KeyTips="设置用户“${MyUserName}”登录秘钥" && ShowColorTipsB
    run_comd="设置用户“${MyUserName}”登录秘钥" && success_info="成功" && failed_info="失败，请稍后手动修改"
    KeyTips="设置用户“${MyUserName}”登录公钥为“${your_public_key}”，请用对应的私钥登录" && ShowColorTipsA
    mkdir -p -m 700 /home/${MyUserName}/.ssh
    echo "${your_public_key}" >/home/${MyUserName}/.ssh/authorized_keys
    chmod 600 /home/${MyUserName}/.ssh/authorized_keys
    chown ${MyUserName}:${MyUserName} -R /home/${MyUserName}/.ssh
    ShowDottedLine
}

# 修改SSH登录端口为${SshPort}
set_ssh_port(){
    KeyTips="修改ssh登录端口为“${SshPort}”" && ShowColorTipsB
    run_comd="修改ssh登录端口为“${SshPort}”" && success_info="成功" && failed_info="失败，请稍后手动修改"
    sed -i "/Port /c Port ${SshPort}" /etc/ssh/sshd_config
    yes_or_no && ShowDottedLine
}

# 开启ssh秘钥登录
set_ssh_key_login_on(){
    KeyTips="开启ssh秘钥登录" && ShowColorTipsB
    run_comd="开启ssh秘钥登录" && success_info="成功" && failed_info="失败，请稍后手动修改"
    sed -i '/PubkeyAuthentication /c PubkeyAuthentication yes' /etc/ssh/sshd_config
    yes_or_no && ShowDottedLine
}

# 禁用密码登录
set_ssh_passwd_login_off(){
    KeyTips="禁用ssh密码登录" && ShowColorTipsB
    run_comd="禁用ssh密码登录" && success_info="成功" && failed_info="失败，请稍后手动修改"
    sed -i '/PasswordAuthentication /c PasswordAuthentication no' /etc/ssh/sshd_config
    yes_or_no && ShowDottedLine
}

# 禁用root用户SSH远程登录
set_root_ssh_login_off(){
    KeyTips="禁用root用户ssh登录" && ShowColorTipsB
    run_comd="禁用root用户ssh登录" && success_info="成功" && failed_info="失败，请稍后手动修改"
    if cat /etc/ssh/sshd_config | grep -q -E -i "PermitRootLogin yes"; then
        sed -i '/PermitRootLogin yes/c PermitRootLogin no' /etc/ssh/sshd_config
        yes_or_no
    else
        if cat /etc/ssh/sshd_config | grep -q -E -i "PermitRootLogin no"; then
            sed -i '/PermitRootLogin no/c PermitRootLogin no' /etc/ssh/sshd_config
            yes_or_no
        else
            echo "PermitRootLogin no" >>/etc/ssh/sshd_config
            yes_or_no
        fi
    fi && ShowDottedLine
    systemctl restart sshd.service
}

#屏幕显示
screen_info(){
    echo -e && echo -e "${color_yellow}请记录以下信息：${color_end}"
    echo -e "       新用户：${MyUserName}"
    echo -e "       ${color_yellow}新用户密码：${MyUserKey}${color_end}"
    echo -e "       root用户密码：${MyRootKey}"
    echo -e "       ${color_yellow}设定公钥对用的私钥${color_end}" && echo -e
}


echo -e && echo -e "${color_yellow}执行模式提醒：${color_end}

    1. 手动模式：每次执行都需输入“新用户、新用户密码、root用户密码、ssh登录端口、公钥”
    ${color_yellow}2. 自动模式：需修改脚本，设定“新用户名、新用户密码、root用户密码、ssh登录端口、公钥”${color_end}
    3. 自定义模式：需要自己删减组合模块" && echo -e

read -n 1 -p """执行“自动模式”请按“y”，按其他任意键执行“手动模式”，“自定义模式”请按ctrl+c退出编辑脚本......""" debian_set_num && echo -e
if [[ ${debian_set_num} == "y" ]]; then
    read -p """你选择“自动模式”，请确认已修改脚本中“新用户名、新用户密码、root用户密码、ssh登录端口、公钥”，按任意键执行""" && echo -e
    del_old_user              #删除home目录下所有用户
    create_new_user           #创建新用户
    create_new_user_passwd    #创建新用户密码
    endow_user_sudo           #设置新用户sduo权限
    set_ssh_key               #设置ssh登录公钥
    set_ssh_port              #设置ssh登录端口
    set_ssh_key_login_on      #开启ssh秘钥登录
    set_ssh_passwd_login_off  #关闭ssh密码登录
    set_root_ssh_login_off    #关闭root用户ssh登录
    screen_info
else
    input_new_user_name     #输入新用户名
    input_new_user_passwd   #输入新用户密码
    input_root_passwd       #输入root用户密码
    input_ssh_port          #输入ssh端口
    input_ssh_key           #输入ssh公钥

    del_old_user              #删除home目录下所有用户
    create_new_user           #创建新用户
    create_new_user_passwd    #创建新用户密码
    endow_user_sudo           #设置新用户sduo权限
    set_ssh_key               #设置ssh登录公钥
    set_ssh_port              #设置ssh登录端口
    set_ssh_key_login_on      #开启ssh秘钥登录
    set_ssh_passwd_login_off  #关闭ssh密码登录
    set_root_ssh_login_off    #关闭root用户ssh登录
    screen_info
fi
