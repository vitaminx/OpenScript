#!/bin/bash

color_yellow='\033[0;32m'
color_end='\033[0m'

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
        echo -e "${color_yellow}${run_comd}${success_info}${color_end}"
    else
        echo -e "${color_yellow}${run_comd}${failed_info}${color_end}"
    fi
    run_comd=""
}

###################################################

#修改hostname
debian_rename_hostname(){
    old_hostname=$(hostnamectl |grep "hostname" |cut -d" " -f6)
    read -p """请输入新的hostname（命名应具有标示性：系统-服务商-机型-编号）
        Input Your New Hostname =>:""" new_hostname && echo -e
    KeyTips="即将修改本机“hostname”" && ShowColorTipsB
    hostnamectl set-hostname ${new_hostname}
    if [ $? -eq 0 ]; then
        KeyTips="“hostname”修改成功" && ShowColorTipsA
        if $(cat /etc/hosts | grep "${new_hostname}" &>/dev/null); then
            ShowColorDottedLine && cat /etc/hosts && ShowColorDottedLine
            KeyTips="hosts文件中“127.0.0.1  ${new_hostname}”记录已存在，稍后重启生效" && ShowColorTipsA
        else
            run_comd="“hosts”文件中添加“127.0.0.1  ${new_hostname}”记录" && success_info="成功，稍后重启生效" && failed_info="失败，请稍后手动修改"
            echo "127.0.0.1  ${new_hostname}" >>/etc/hosts
            yes_or_no
            ShowColorDottedLine && cat /etc/hosts && ShowColorDottedLine
        fi
        #删除旧hostname设置
        if $(cat /etc/hosts | grep "127.0.0.1.*${old_hostname}" &>/dev/null); then
            KeyTips="删除hosts文件中“$(cat /etc/hosts | grep "127.0.0.1.*${old_hostname}")”记录" && ShowColorTipsB
            run_comd="删除hosts文件中“$(cat /etc/hosts | grep "127.0.0.1.*${old_hostname}")”记录" && success_info="成功" && failed_info="失败，请稍后手动删除"
            sed -i "/127.0.0.1.*${old_hostname}/d" /etc/hosts &>/dev/null
            yes_or_no
            ShowColorDottedLine && cat /etc/hosts && ShowColorDottedLine
        fi
    else
        KeyTips="“hostname”修改失败，稍后请手动修改" && ShowColorTipsA
    fi
}

debian_rename_hostname && echo -e
#read -s -n1 -p "hostname已修改为“${new_hostname}”，按任意键重启系统生效，按“ctrl+c”退出...... " && echo -e && reboot
