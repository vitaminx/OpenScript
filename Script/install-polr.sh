#!/bin/bash
# 宝塔部署-ssoo.ga
# “Polr短链接”项目部署

#======================= 基础函数 ======================
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
#======================================================
polr_cydrobolt(){
    domain_polr="ssoo.ga"

    cd /www/wwwroot/${domain_polr}
    git clone https://github.com/cydrobolt/polr.git --depth=1
    mv polr/{.,}* ./ && rm -rf /www/wwwroot/${domain_polr}/polr

    #下载汉化文件
    cd resources && rm -rf views && wget https://www.moerats.com/usr/down/porl_views.tar.gz
    tar zxvf porl_views.tar.gz
    cd ..

    #设置权限
    chmod -R 755 /www/wwwroot/${domain_polr}
    chown -R www:www /www/wwwroot/${domain_polr}

    #安装composer并安装网站
    curl -sS https://getcomposer.org/installer | php
    php composer.phar install --no-dev -o

    cp .env.setup .env
    chown -R www:www /www/wwwroot/${domain_polr}
}

polr_skywalker512(){
    domain_polr="ssoo.ga"

    #克隆汉化版并移动文件
    cd /www/wwwroot/${domain_polr}
    git clone https://github.com/skywalker512/polr.git
    mv polr/{.,}* ./ && rm -rf /www/wwwroot/${domain_polr}/polr

    #设置权限
    chmod -R 755 /www/wwwroot/${domain_polr}
    chown -R www:www /www/wwwroot/${domain_polr}

    #安装composer并安装网站
    curl -sS https://getcomposer.org/installer | php
    php composer.phar install --no-dev -o

    rm -rf /www/wwwroot/${domain_polr}/composer.phar
    cp .env.setup .env
    chown -R www:www /www/wwwroot/${domain_polr}
}

polr_skywalker512