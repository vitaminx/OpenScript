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

#安装基础软件（curl/wget/sudo/htop）
debian_install_basic_software(){
    KeyTips="请选择VPS硬件资源类型（硬件资源不同安装基础软件不同）" && echo && ShowColorTipsA

    echo -e "
     1. 超微VPS（内存1G以下,基础软件只装“curl/wget/sudo/htop”）
    ${color_yellow} 2. 小型VPS（内存1G以上CPU2核及以上,安装cgking脚本oneking修改版） ${color_end}
     3. 性能VPS（内存4G以上CPU2核及以上,安装特定服务）
    ${color_yellow} 4. 杜甫（特殊用途待定） ${color_end}" && echo -e

    vps_hardware_resources=1
    while [ ${vps_hardware_resources} == 1 ]; do
        read -n 1 -p """请选择VPS类型（回车直接选择“超微VPS”）
        选择VPS类型序号 [ 1--4 ] =>:""" vps_hardware_resources&& echo -e
        vps_hardware_resources=${vps_hardware_resources:-1}
        if [ ${vps_hardware_resources} -eq 1 ]; then
            basic_softs_info="安装基础软件（curl/wget/sudo/htop）"
            KeyTips="你选择的VPS类型为“超微VPS”，基础软件只装“curl/wget/sudo/htop”，即将为你安装" && ShowColorTipsB
            run_comd="“curl/wget/sudo/htop”等软件安装" && success_info="成功" && failed_info="失败，请稍后手动安装"
            apt install -y curl wget sudo htop
            yes_or_no
            ShowColorDottedLine
            break
        elif [ ${vps_hardware_resources} -eq 2 ]; then
            basic_softs_info="安装“cgking一键装机脚本oneking修改版”项目"
            KeyTips="你选择的VPS类型为“小型VPS”，执行cgking脚本oneking修改版，即将执行" && ShowColorTipsB
            bash <(curl -sL ecgcc.cc/cg1k) --basic    #执行cgking的一键设置脚本oneking修改版（去掉“x-ui、禁用swap、重启”）
            break
        elif [ ${vps_hardware_resources} -eq 3 ]; then
            basic_softs_info="安装“cgking一键装机脚本oneking修改版”项目"
            KeyTips="你选择的VPS类型为“性能VPS”，执行cgking脚本oneking修改版，即将执行" && ShowColorTipsB
            bash <(curl -sL ecgcc.cc/cg1k) --basic    #执行cgking的一键设置脚本oneking修改版（去掉“x-ui、禁用swap、重启”）
            break
        elif [ ${vps_hardware_resources} -eq 4 ]; then
            basic_softs_info="安装“cgking一键装机脚本oneking修改版”项目"
            KeyTips="你选择的VPS类型为“杜甫VPS”，执行cgking脚本oneking修改版，即将执行" && ShowColorTipsB
            bash <(curl -sL ecgcc.cc/cg1k) --basic    #执行cgking的一键设置脚本oneking修改版（去掉“x-ui、禁用swap、重启”）
            break
        else
            KeyTips="请选择正确的VPS类型，或按ctrl+c退出" && ShowColorTipsB
            vps_hardware_resources=1
        fi
    done
}

#屏幕显示
debian_info_screen(){
    echo -e && echo -e "${color_yellow}本次任务部署的项目及设置的参数如下：${color_end}"
    echo -e "    ${color_yellow}${basic_softs_info}${color_end}" && echo -e
}

debian_install_basic_software
debian_info_screen
read -s -n1 -p "${basic_softs_info}已完成，按任意键重启系统...... " && echo -e && reboot
