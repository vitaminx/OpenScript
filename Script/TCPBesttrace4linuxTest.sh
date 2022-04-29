#!/bin/bash
###################### 参 数 设 置 ######################
    # 颜色参数
    color_yellow='\033[0;32m'
    color_end='\033[0m'

    # 设置参数
    YourTestIP="61.144.56.100"
########################################################
    # 输出单虚线(内部分隔)
    ShowDottedLine(){
        echo -e "------------------------------------------------"
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
        # 用本函数必须配置三个变量“run_comd” “success_info” “failed_info”
        if [ $? -eq 0 ]; then
            echo -e "${color_yellow}${run_comd}${success_info}${color_end}"
        else
            echo -e "${color_yellow}${run_comd}${failed_info}${color_end}"
        fi
        run_comd=""
    }
########################################################

download_softwera(){
    KeyTips="开始下载TCP回程测试软件“BestTrace”Linux版并设置权限" && ShowColorTipsB
    mkdir -p /home/besttrace
    chmod -R 777 /home/besttrace
    cd /home/besttrace
    wget https://github.com/vitaminx/OpenScript/blob/main/Software/besttrace4linux-1.zip
    wget https://github.com/vitaminx/OpenScript/blob/main/Software/besttrace4linux-2.zip
    unzip besttrace*.zip
    chmod -R 777 /home/besttrace
}

input_testip(){
    #输入测试ip
    read -p """请输入回程连接的测试IP（一般输入测试电脑外网IP）
    Input Your Test IP =>:""" YourTestIP && echo -e
    KeyTips="你输入的TCP回程测试IP为“${YourTestIP}”，即将为你进行回程测试" && ShowColorTipsA
}

besttrace4linux() {
    download_softwera
    echo -e && KeyTips="回程测试模式：" && ShowColorTipsA
    echo -e "
     1. 内置IP回程测试（内置IP为广州电信IP）
    ${color_yellow} 2. 指定IP回程测试（需要输入VPS连接IP） ${color_end}" && echo -e
    besttrace4linux_num=1
    while [ ${besttrace4linux_num} == 1 ]; do
        read -n 1 -p """请选择回程测试模式，按1选择“内置IP回程测试”，按9退出测试，按其他任意键选择“指定IP回程测试”,退出请安ctrl+c......""" besttrace4linux_num && echo -e
        besttrace4linux_num=${besttrace4linux_num:-100}
        if [ ${besttrace4linux_num} -eq 1 ]; then
            KeyTips="你选择的测试模式为“内置IP回程测试”，IP地址为广州电信“61.144.56.100”即将为你测试" && ShowColorTipsB
            /home/besttrace/besttrace ${YourTestIP}
            besttrace4linux_num=1 && ShowDottedLine
        elif [ ${besttrace4linux_num} -eq 9 ]; then
            KeyTips="你选择退出测试，即将为你删除测试软件并退出" && ShowColorTipsB
            run_comd="删除测试软件" && success_info="成功并退出" && failed_info="失败，请手动删除"
            rm -rf /home/besttrace &>/dev/null
            yes_or_no && echo -e
            break
        else
            KeyTips="你选择的测试模式为“指定IP回程测试”" && ShowColorTipsB
            input_testip
            /home/besttrace/besttrace ${YourTestIP}
            besttrace4linux_num=1 && ShowDottedLine
        fi
    done
}