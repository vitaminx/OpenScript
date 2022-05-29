#!/bin/bash
# 网络畅通测试（连接Google）
# 字体颜色（红色-绿色-黄色）
color_red='\033[0;31m'
color_green='\033[0;32m'
color_yellow='\033[0;33m'
color_end='\033[0m'
Info="${color_green}[信息]${color_end}"
Error="${color_red}[错误]${color_end}"
Tip="${color_yellow}[注意]${color_end}"

# o7-检测网络链接畅通(www.google.com)
detect_network_link() {
    #超时时间
    local timeout=1
    #目标网站
    local target="www.google.com"
    #获取响应状态码
    local ret_code=$(curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | tail -n1)
    if [ "x$ret_code" = "x200" ]; then
        echo -e && echo -e "${color_yellow}连接“www.google.com”成功，网络畅通、可以科学上网......${color_end}" && echo -e
        return 1
    else
        echo -e && echo -e "${color_yellow}连接“www.google.com”失败，网络不通、可以洗洗睡了......${color_end}" && echo -e
        return 0
    fi
    return 0
}
detect_network_link
