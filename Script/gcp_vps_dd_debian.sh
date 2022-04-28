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

input_ip_addr(){
    read -p """请输入需要DD的GCP实例的内网IP地址（一般是10开，格式如：10.146.0.25，注意不是外网IP）
        Input Your VPS IP ADDR =>:""" ip_addr && echo -e

    ip_addr_1=$(echo "${ip_addr}" |cut -d"." -f1)
    ip_addr_2=$(echo "${ip_addr}" |cut -d"." -f2)
    ip_addr_3=$(echo "${ip_addr}" |cut -d"." -f3)
    ip_addr_4=$(echo "${ip_addr}" |cut -d"." -f4)

    ip_gate="${ip_addr_1}.${ip_addr_2}.${ip_addr_3}.1"
}

input_ip_mask(){
    read -p """请输入需要DD的GCP实例的子网掩码地址（掩码查询地址：https://www.sojson.com/convert/subnetmask.html；“20”对应“255.255.240.0”、“24”对应的“255.255.255.0”）
        Input Your VPS IP MASK =>:""" ip_mask && echo -e
}

input_root_passwd(){
    read -p """请设置DD系统后“root”用户登录密码（系统DD后用此密码登录）
        Input Your OS ROOT PASSWD =>:""" root_passwd && echo -e
}

input_ssh_port(){
    read -p """请设置DD系统后“ssh”登录端口（ssh软件登录的端口设置）
        Input Your OS SSH PORT =>:""" ssh_port && echo -e
}

input_os_num(){
    read -p """请输入DD系统的版本号（Debian系统支持9/10/11等版本）
        Input Your SO NUM =>:""" debian_ver && echo -e
}

# 选择一键脚本
change_ddscriptlink() {
    KeyTips="请选择需要执行的“DD一键脚本”，注意不同的脚本适用的系统不同" && ShowColorTipsB
    echo -e "
     1. MoeClub脚本-萌卡源（适用于Debian9/10，不实用11版）
    ${color_yellow} 2. MoeClub脚本-Github源（适用于Debian9/10，不实用11版）${color_end}
     3. 待补充源（......）
    ${color_yellow} 4. 待补充源（......）${color_end}" && echo
    change_ddscriptlink_num=1
    while [ ${change_ddscriptlink_num} == 1 ]; do
        read -n 1 -t 15 -p """请选择需要执行的“DD一键脚本”（15秒钟未选择自动选择“MoeClub老版本（适用于Debian9/10，不实用11版）”进行DD）
        所选脚本序号 [ 1--4 ] =>:""" change_ddscriptlink_num && echo -e
        change_ddscriptlink_num=${change_ddscriptlink_num:-1}
        if [ ${change_ddscriptlink_num} -eq 1 ]; then
            KeyTips="你所选的DD脚本为“MoeClub脚本-萌卡源”，注意此脚本只适用于Debian9/10" && ShowColorTipsA
            ddscriptlink='https://moeclub.org/attachment/LinuxShell/InstallNET.sh'
            ddscriptlink_name="MoeClub脚本-萌卡源"
            ddscriptlink_info="适用于Debian9/10"
            break
        elif [ ${change_ddscriptlink_num} -eq 2 ]; then
            KeyTips="你所选的DD脚本为“MoeClub脚本-Github源”，注意此脚本只适用于Debian9/10" && ShowColorTipsA
            ddscriptlink='https://raw.githubusercontent.com/MoeClub/Note/master/InstallNET.sh'
            ddscriptlink_name="MoeClub脚本-Github源"
            ddscriptlink_info="适用于Debian9/10"
            break
        elif [ ${change_ddscriptlink_num} -eq 3 ]; then
            KeyTips="" && ShowColorTipsA
            ddscriptlink=''
            ddscriptlink_name=""
            ddscriptlink_info=""
            break
        elif [ ${change_ddscriptlink_num} -eq 4 ]; then
            KeyTips="" && ShowColorTipsA
            ddscriptlink=''
            ddscriptlink_name=""
            ddscriptlink_info=""
            break
        else
            KeyTips="请选择正确的脚本编号，或按ctrl+c退出！" && ShowColorTipsA && echo -e
            change_ddscriptlink_num=1
        fi
    done && echo -e
}

input_ip_addr
#input_ip_mask
ip_mask="255.255.255.0"
input_root_passwd
input_ssh_port
change_ddscriptlink
#input_os_num
debian_ver=10
echo -e && echo -e "本次GCP系统DD信息如下：
    内部IP地址：${ip_addr}
    内部网关：${ip_gate}
    掩码地址：${ip_mask}
    root用户密码：${root_passwd}
    ssh登录端口：${ssh_port}
    DD的系统级版本：Debian ${debian_ver}
    DD一键脚本名：${ddscriptlink_name}
    DD一键脚本链接：${ddscriptlink}
    DD一键脚本说明：${ddscriptlink_info}" && echo -e

read -n 1 -p """即将为你的GCP实例DD安装“Debian${debian_ver}”系统，确认安装请按“y”，按其他任意键终止执行脚本......""" ssh_num && echo -e
if [[ ${ssh_num} == "y" ]]; then
    KeyTips="下面开始安装DD系统所需依赖软件" && ShowColorTipsB
    apt-get install -y xz-utils openssl gawk file wget
    KeyTips="下面开始DD安装系统“Debian ${debian_ver}”" && ShowColorTipsB
    run_comd="系统Debian${debian_ver}软件包下载" && success_info="成功，即将重启安装系统“Debian${debian_ver}”" && failed_info="失败，请按“ctrl+c”终止脚本执行并退出"

    #bash <(wget --no-check-certificate -qO- ${ddscriptlink}) --ip-addr ${ip_addr} --ip-gate ${ip_gate} --ip-mask ${ip_mask} -d ${debian_ver} -v 64 -a -p "${root_passwd}" -port "${ssh_port}"

    bash <(curl -sL ${ddscriptlink}) --ip-addr ${ip_addr} --ip-gate ${ip_gate} --ip-mask ${ip_mask} -d ${debian_ver} -v 64 -a -p "${root_passwd}" -port "${ssh_port}"
    yes_or_no
fi
