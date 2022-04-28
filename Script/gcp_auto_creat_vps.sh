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

read -p """请输入你需要创建的VPS数量并回车（注意GCP限定每个区8个IP）
        Input Your VPS NUM =>:""" vps_num && echo -e

read -p """请输入你需要创建的VPS名前缀并回车（VPS命名规则为：前缀-数字编码）
        Input Your VPS NAME PRE =>:""" vps_name_pre && echo -e

read -p """请输入你需要创建的VPS后缀起始编码（VPS命名规则为：前缀-后缀编码）
        Input Your VPS NAME SUF =>:""" vps_name_suf && echo -e

read -p """请输入你创建VPS的配置代码（在VPS的创建页面获取的“等效命令行”中VPS名后面带“--”部分，从“--project=”开始）
        Input Your VPS NUM =>:""" create_vps_config_code && echo -e

zone_engine="$(echo "${create_vps_config_code}" |cut -d" " -f2 |cut -d"=" -f2)"                   #机房所在地
machine_type="$(echo "${create_vps_config_code}" |cut -d" " -f3 |cut -d"=" -f2)"                  #实例类型
source_machine_image="$(echo "${create_vps_config_code}" |cut -d"=" -f15)"                        #实例类型

echo -e && echo -e "本次作业信息如下：
    创建VPS数量为：${vps_num}台
    所在地区为：${zone_engine}
    实例类型为：${machine_type}
    所用镜像为：${source_machine_image}" && echo -e

KeyTips="下面开始自动创建，每台VPS之间间隔三分钟" && ShowColorTipsB
num=1
while ((num <= ${vps_num})); do
    echo -e && ShowColorDottedLine && echo -e
    KeyTips="开始创建第${num}台VPS：${vps_name_pre}-${vps_name_suf}" && ShowColorTipsB
    (gcloud beta compute instances create ${vps_name_pre}-${vps_name_suf} ${create_vps_config_code}) &
    pid=$!
    (sleep 180 && kill -HUP $pid) 2>/dev/null &
    watcher=$!
    if wait $pid 2>/dev/null; then
        pkill -HUP -P $watcher
        wait $watcher
        KeyTips="成功创建第${num}台VPS：${vps_name_pre}-${vps_name_suf}" && ShowColorTipsA
    else
        KeyTips="创建第${num}台VPS“${vps_name_pre}-${vps_name_suf}”失败" && ShowColorTipsB
    fi
    let "vps_name_suf += 1"
    let "num += 1"
done && echo -e
