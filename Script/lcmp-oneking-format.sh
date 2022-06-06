#!/bin/bash
#本脚本修改：去掉“InstallFirewall”+删除caddy
clear
echo '================================================================'
echo ' 此程序仅供学习,执行请用虚拟机,一切后果与本人无关'
echo ' 禁止使用本脚本创建违规违法网站，发现将举报'
echo '================================================================'
if grep -i "CentOS" /etc/*-release || grep -i "Rocky" /etc/*-release || grep -i "Alma" /etc/*-release; then
	echo centos ok
elif grep -i "Fedora" /etc/issue || grep -i "Fedora" /etc/*-release; then
	echo "Fedora" ok
elif grep -i "Debian" /etc/issue; then
	echo Debian ok
elif grep -i "Ubuntu" /etc/issue; then
	echo Ubuntu ok
else
	echo "Sorry, we haven't matched your system yet. You can give us feedback"
	echo "识别不出您的系统，您可以向我们反馈"
	exit
fi
if [ -n "$1" ]; then
	echo "OK The database version entered is $1"
	DBselect=$1
fi
if [ -n "$2" ]; then
	echo "OK You will use $2"
	ftpint=$2
fi
#ver
lcmp_ver() {
	loshub="http://source.loshub.com"
	pureftp=$(curl $loshub/ver/pureftp4.txt)
	mysqlver=$(curl $loshub/ver/mysql5.7.txt)
	mysql80=$(curl $loshub/ver/mysql8.0.txt)
	mariadb102=$(curl $loshub/ver/mariadb10.2.txt)
	mariadb103=$(curl $loshub/ver/mariadb10.3.txt)
	mariadb104=$(curl $loshub/ver/mariadb10.4.txt)
	mariadb105=$(curl $loshub/ver/mariadb10.5.txt)
	libgd=$(curl $loshub/ver/gd.txt)
	openssl=$(curl $loshub/ver/openssl.txt)
	openssl11=$(curl $loshub/ver/openssl1.1.txt)
	autoconf=$(curl $loshub/ver/autoconf.txt)
	caddy=$(curl $loshub/ver/caddy.txt)
	libiconv=$(curl $loshub/ver/libiconv.txt)
	libzip=$(curl $loshub/ver/libzip.txt)
	freetype=$(curl $loshub/ver/freetype.txt)
	curl=$(curl $loshub/ver/curl.txt)
	oniguruma=$(curl $loshub/ver/oniguruma.txt)
	apcu5=$(curl $loshub/ver/apcu5.txt)
	Php74=$(curl $loshub/ver/php7.4.txt)
	MysqlPass=$(tr -cd '[:alnum:]' </dev/urandom | fold -w10 | head -n1)
	go=$(curl $loshub/ver/go.txt)
	Domain=$(curl icanhazip.com)
}
lcmp_ver_log() {
	echo -e "${pureftp}" >lcmp-oneking-ver.log
	echo -e "mysqlver-${mysqlver}" >>lcmp-oneking-ver.log
	echo -e "mysql80-${mysql80}" >>lcmp-oneking-ver.log
	echo -e "${mariadb102}" >>lcmp-oneking-ver.log
	echo -e "${mariadb103}" >>lcmp-oneking-ver.log
	echo -e "${mariadb104}" >>lcmp-oneking-ver.log
	echo -e "${mariadb105}" >>lcmp-oneking-ver.log
	echo -e "libgd-${libgd}" >>lcmp-oneking-ver.log
	echo -e "${openssl}" >>lcmp-oneking-ver.log
	echo -e "${openssl11}" >>lcmp-oneking-ver.log
	echo -e "${autoconf}" >>lcmp-oneking-ver.log
	echo -e "${caddy}" >>lcmp-oneking-ver.log
	echo -e "${libiconv}" >>lcmp-oneking-ver.log
	echo -e "${libzip}" >>lcmp-oneking-ver.log
	echo -e "${freetype}" >>lcmp-oneking-ver.log
	echo -e "${curl}" >>lcmp-oneking-ver.log
	echo -e "${oniguruma}" >>lcmp-oneking-ver.log
	echo -e "${apcu5}" >>lcmp-oneking-ver.log
	echo -e "${Php74}" >>lcmp-oneking-ver.log
	echo -e "MysqlPass：${MysqlPass}" >>lcmp-oneking-ver.log
	echo -e "${go}" >>lcmp-oneking-ver.log
	echo -e "${Domain}" >>lcmp-oneking-ver.log
}
lcmp_oneking_ver_log() {
	loshub="http://source.loshub.com"
	pureftp=$(curl $loshub/ver/pureftp4.txt)
	echo -e "${pureftp}" >lcmp-oneking-ver.log
	mysqlver=$(curl $loshub/ver/mysql5.7.txt)
	echo -e "mysqlver-${mysqlver}" >>lcmp-oneking-ver.log
	mysql80=$(curl $loshub/ver/mysql8.0.txt)
	echo -e "mysql80-${mysql80}" >>lcmp-oneking-ver.log
	mariadb102=$(curl $loshub/ver/mariadb10.2.txt)
	echo -e "${mariadb102}" >>lcmp-oneking-ver.log
	mariadb103=$(curl $loshub/ver/mariadb10.3.txt)
	echo -e "${mariadb103}" >>lcmp-oneking-ver.log
	mariadb104=$(curl $loshub/ver/mariadb10.4.txt)
	echo -e "${mariadb104}" >>lcmp-oneking-ver.log
	mariadb105=$(curl $loshub/ver/mariadb10.5.txt)
	echo -e "${mariadb105}" >>lcmp-oneking-ver.log
	libgd=$(curl $loshub/ver/gd.txt)
	echo -e "libgd-${libgd}" >>lcmp-oneking-ver.log
	openssl=$(curl $loshub/ver/openssl.txt)
	echo -e "${openssl}" >>lcmp-oneking-ver.log
	openssl11=$(curl $loshub/ver/openssl1.1.txt)
	echo -e "${openssl11}" >>lcmp-oneking-ver.log
	autoconf=$(curl $loshub/ver/autoconf.txt)
	echo -e "${autoconf}" >>lcmp-oneking-ver.log
	caddy=$(curl $loshub/ver/caddy.txt)
	echo -e "${caddy}" >>lcmp-oneking-ver.log
	libiconv=$(curl $loshub/ver/libiconv.txt)
	echo -e "${libiconv}" >>lcmp-oneking-ver.log
	libzip=$(curl $loshub/ver/libzip.txt)
	echo -e "${libzip}" >>lcmp-oneking-ver.log
	freetype=$(curl $loshub/ver/freetype.txt)
	echo -e "${freetype}" >>lcmp-oneking-ver.log
	curl=$(curl $loshub/ver/curl.txt)
	echo -e "${curl}" >>lcmp-oneking-ver.log
	oniguruma=$(curl $loshub/ver/oniguruma.txt)
	echo -e "${oniguruma}" >>lcmp-oneking-ver.log
	apcu5=$(curl $loshub/ver/apcu5.txt)
	echo -e "${apcu5}" >>lcmp-oneking-ver.log
	Php74=$(curl $loshub/ver/php7.4.txt)
	echo -e "${Php74}" >>lcmp-oneking-ver.log
	MysqlPass=$(tr -cd '[:alnum:]' </dev/urandom | fold -w10 | head -n1)
	echo -e "MysqlPass：${MysqlPass}" >>lcmp-oneking-ver.log
	go=$(curl $loshub/ver/go.txt)
	echo -e "${go}" >>lcmp-oneking-ver.log
	Domain=$(curl icanhazip.com)
	echo -e "${Domain}" >>lcmp-oneking-ver.log
}
lcmp_oneking_ver_log
#stop se
if grep -i "CentOS" /etc/*-release || grep -i "Rocky" /etc/*-release || grep -i "Alma" /etc/*-release || grep -i "Fedora" /etc/*-release; then
	setenforce 0
	sed -i "s#SELINUX=enforcing#SELINUX=disabled#g" /etc/selinux/config
fi
# Function List	*****************************************************************************
function CheckSystem() {
	Cpunum=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
	RamTotal=$(free -m | grep 'Mem' | awk '{print $2}')
	RamSwap=$(free -m | grep 'Swap' | awk '{print $2}')
	if [ ! -n "RamSwap" ]; then
		Ramzh=$(expr $RamTotal + $RamSwap)
	else
		Ramzh=$RamTotal
	fi
	swapoff -a
	dd if=/dev/zero of=/swapfile bs=1M count=1200
	mkswap /swapfile
	swapon /swapfile
	echo "/swapfile       swap    swap defaults   0 0" >>/etc/fstab
	Cpunum=$(cat /proc/cpuinfo | grep 'processor' | wc -l)
	RamTotal=$(free -m | grep 'Mem' | awk '{print $2}')
	RamSwap=$(free -m | grep 'Swap' | awk '{print $2}')
	Ramzh=$(expr $RamTotal + $RamSwap)
	echo $RamTotal $RamSwap $Ramzh
	if [ "$Ramzh" -ge 1100 ]; then
		fileinfo=--enable-fileinfo
	else
		fileinfo=--disable-fileinfo
	fi
	echo "${SysBit}Bit, ${Cpunum}*CPU, ${RamTotal}MB*RAM, ${RamSwap}MB*Swap"
	echo '================================================================'
}
function ConfirmInstall() {
	if [ ! -d "/var/lib/mysql" ] || [ ! -d "/usr/local/mysql" ]; then
		if [ ! -n "$DBselect" ]; then
			echo "[Notice] Confirm Install Mysql? please select: (1~9)"
			select DBselect in 'mysql5.5' 'mysql5.6' 'mysql5.7' 'mariadb10.1' 'mariadb10.2' 'mariadb10.3' 'mariadb10.4' 'mariadb10.5' 'mysql8.0' 'nomysql'; do break; done
			if [ "$DBselect" == 'mysql5.5' ]; then
				confirm='1' && echo '[OK] mysql-5.5 installed'
			elif [ "$DBselect" == 'mysql5.6' ]; then
				confirm='2' && echo '[OK] Mysql-5.6 installed'
			elif [ "$DBselect" == 'mysql5.7' ]; then
				confirm='3' && echo '[OK] mysql-5.7 installed'
			elif [ "$DBselect" == 'mariadb10.1' ]; then
				confirm='4' && echo '[OK] mariadb-10.1 installed'
			elif [ "$DBselect" == 'mariadb10.2' ]; then
				confirm='5' && echo '[OK] mariadb-10.2 installed'
			elif [ "$DBselect" == 'mariadb10.3' ]; then
				confirm='6' && echo '[OK] mariadb-10.3 installed'
			elif [ "$DBselect" == 'mariadb10.4' ]; then
				confirm='7' && echo '[OK] mariadb-10.4 installed'
			elif [ "$DBselect" == 'mariadb10.5' ]; then
				confirm='8' && echo '[OK] mariadb-10.5 installed'
			elif [ "$DBselect" == 'mysql8.0' ]; then
				confirm='9' && echo '[OK] mysql8.0 installed'
			elif [ "$DBselect" == 'nomysql' ]; then
				echo 'Not Install mysql.'
			else
				echo 'Unable to recognize, re-enter,无法识别，重新录入'
				ConfirmInstall
			fi
		else
			if [ "$DBselect" == 'mysql5.5' ]; then
				confirm='1' && echo '[OK] mysql-5.5 installed'
			elif [ "$DBselect" == 'mysql5.6' ]; then
				confirm='2' && echo '[OK] Mysql-5.6 installed'
			elif [ "$DBselect" == 'mysql5.7' ]; then
				confirm='3' && echo '[OK] mysql-5.7 installed'
			elif [ "$DBselect" == 'mariadb10.1' ]; then
				confirm='4' && echo '[OK] mariadb-10.1 installed'
			elif [ "$DBselect" == 'mariadb10.2' ]; then
				confirm='5' && echo '[OK] mariadb-10.2 installed'
			elif [ "$DBselect" == 'mariadb10.3' ]; then
				confirm='6' && echo '[OK] mariadb-10.3 installed'
			elif [ "$DBselect" == 'mariadb10.4' ]; then
				confirm='7' && echo '[OK] mariadb-10.4 installed'
			elif [ "$DBselect" == 'mariadb10.5' ]; then
				confirm='8' && echo '[OK] mariadb-10.5 installed'
			elif [ "$DBselect" == 'mysql8.0' ]; then
				confirm='9' && echo '[OK] mysql8.0 installed'
			elif [ "$DBselect" == 'nomysql' ]; then
				echo 'Not Install mysql.'
			else
				echo "我不明白你输入的MySQL版本,默认情况下安装MySQL 5.6"
				echo "I don't understand You enter MySQL version. MySQL 5.6 is installed by default"
				confirm='2' && echo '[OK] Mysql-5.6 installed'
			fi
		fi
	fi
}
function installftp() {
	if [ ! -n "$ftpint" ]; then
		echo "[Notice] Confirm Install pureftpd? please select: (1~2)"
		select ftpint in 'ftp' 'noftp'; do break; done
		if [ "$ftpint" == 'ftp' ]; then
			ftpinstall=1
			echo '[OK] pureftpd installed'
		elif [ "$ftpint" == 'noftp' ]; then
			echo '[OK] Do not install pureftpd'
		else
			echo 'Unable to recognize, re-enter,无法识别，重新录入'
			installftp
		fi
	else
		if [ "$ftpint" == 'ftp' ]; then
			ftpinstall=1
			echo '[OK] pureftpd installed'
		elif [ "$ftpint" == 'noftp' ]; then
			echo '[OK] Do not install pureftpd'
		else
			echo 'The number you entered is incorrect. Pureftpd is installed by default'
			ftpinstall=1
		fi
	fi
}
function Installyum() {
	if grep -i "CentOS" /etc/*-release || grep -i "Rocky" /etc/*-release || grep -i "Alma" /etc/*-release || grep -i "Fedora" /etc/*-release; then
		if grep 7.* /etc/*-release | grep -i centos; then
			wget $loshub/linux/centos7/epel-release-latest-7.noarch.rpm
			rpm -Uvh epel-release-latest-7.noarch.rpm
			rm -rf epel-release-latest-7.noarch.rpm
		fi
		yum install epel-release -y && yum update -y
		yum install -y cmake gcc gcc-c++ make automake zlib openssl openssl-devel
		yum -y install libssh* && yum -y install ncurses*
		yum -y install wget bison-runtime ncurses-devel bison perl perl-devel tar
		yum -y install libxml2-devel libcurl-devel libedit* bzip2 bzip2-devel curl curl-devel libpng-devel openldap openldap-devel
		yum -y install libjpeg-devel freetype-devel pcre-devel zlib-devel
		yum -y install ftp glibc patch expat-devel *libunwind*
		yum -y install *png* *jpeg*
		yum -y install libaio libaio-devel libcap icu libtiff-devel libicu libicu-devel gettext gettext-devel libidn* libxslt libxslt-devel libXpm-devel pam-devel libevent-devel gd zip crontabs file mlocate flex diffutils glibc-devel glib2 glib2-devel net-tools logrotate
		yum install -y readline-devel sqlite-devel libpng
		yum -y install unzip m4 autoconf libzip
		yum install libmemcached libmemcached-devel bison-devel -y
		yum install -y gcc-g77
		yum install -y mcrypt db4-devel glibc-static krb5 pspell-devel
		yum install -y libstdc++-static
		yum install quota oniguruma* libtool* -y
		yum install lftp libtirpc* libpcre* -y
		yum install perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker -y
		yum install perl-ExtUtils-Embed -y
		yum install jemalloc jemalloc-devel -y
		yum install rcs -y
		yum install libc-client-devel -y
		yum install numactl numactl-devel -y
		if grep 7.* /etc/*-release | grep -i centos; then
			wget $loshub/linux/cmake/cmake-3.15.5.tar.gz
			tar -zxf cmake-3.15.5.tar.gz && cd cmake-3.15.5
			./bootstrap --system-curl --prefix=/usr && gmake -j$Cpunum && gmake install
			cd .. && rm -rf cmake-3.15.5 cmake-3.15.5.tar.gz
			wget $loshub/linux/centos7/libstdc/libstdc++.so.6.0.25.tar.gz
			tar zxf libstdc++.so.6.0.25.tar.gz
			rm -rf libstdc++.so.6.0.25.tar.gz
			mv libstdc++.so.6.0.25 /usr/lib64
			rm -rf /usr/lib64/libstdc++.so.6
			ln -s /usr/lib64/libstdc++.so.6.0.25 /usr/lib64/libstdc++.so.6
		fi
		if grep 9.* /etc/*-release | grep -i centos; then
			wget $loshub/linux/libtirpc/libtirpc-1.3.2.tar.bz2
			tar -xjf libtirpc-1.3.2.tar.bz2
			cd libtirpc-1.3.2
			./configure --disable-gssapi
			make -j4 && make install
			cd .. && rm -rf libtirpc-1.3.2 libtirpc-1.3.2.tar.bz2
		fi
	elif grep -i "Debian" /etc/issue; then
		rm -rf /var/lib/dpkg/lock-frontend
		rm -rf /var/lib/dpkg/lock
		rm -rf /var/lib/dpkg/lock-frontend
		rm -rf /var/lib/dpkg/lock
		rm -rf /var/cache/apt/archives/lock
		rm -rf /var/cache/apt/archives/
		dpkg --configure -a
		mv /var/lib/dpkg/info /var/lib/dpkg/info.bk
		mkdir /var/lib/dpkg/info
		apt-get update -y
		apt-get install -f
		apt install curl wget gcc g++ libpcre3 libpcre3-dev zlib1g-dev libpcre++-dev git libssl-dev openssl libssl-dev zlib1g-dev sqlite3 libsqlite3-dev autoconf build-essential libreadline-dev unzip zip -y
		apt install libxml2 libxml2-dev libfreetype6-dev libjpeg-dev libcurl4-gnutls-dev libpng-dev libpng-dev libgtk2.0-dev libssl-dev libxslt-dev libmcrypt-dev libaio-dev -y
		apt install git-core gnupg flex bison gperf build-essential zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc u-boot-tools gawk -y
		apt install build-essential less psmisc libxslt1-dev cpp libxslt1-dev cmake make ntp logrotate automake m4 patch autoconf2.13 re2c cron libpam0g-dev libzip-dev libc6-dev rcconf cpp binutils tar bzip2 libncurses5-dev libncurses5 libtool libevent-dev libssl-dev libsasl2-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-0 libglib2.0-dev libfreetype6 libfreetype6-dev libpng-dev libpq-dev libpq5 gettext libcap-dev ftp expect -y
		apt install libkrb5-dev libncurses* -y
		apt-get install libonig-dev libltdl7 numactl freetype* golang -y
		apt-get install libonig-dev automake libtool -y
		apt-get install libcurl4-openssl-dev libcurl4-gnutls-dev -y
		apt install libaio1 libnuma1 libmecab2 -y
		apt-get install libmemcached-dev -y
		apt-get install readline -y
		apt-get install libeditreadline-dev -y
		apt-get install libreadline-gplv2-dev zlibc -y
		apt-get install libreadline-dev -y
		apt-get install libsqlite3-dev -y
		apt-get install quota lftp -y
		apt-get install libtirpc* -y
		apt-get install libpcre* -y
		apt-get install freeglut3-dev -y
		apt autoremove -y
	elif grep -i "Ubuntu" /etc/issue; then
		rm -rf /var/cache/apt/archives/lock
		rm -rf /var/lib/dpkg/lock
		apt-get remove apache* -y
		apt-get update -y
		dpkg --purge kate
		dpkg --purge kscope
		rm -rf /var/lib/dpkg/lock-frontend
		apt-get install curl wget gcc g++ libpcre3 libpcre3-dev libpcre++-dev git openssl -y
		apt-get install sqlite sqlite3 libsqlite3-dev autoconf unzip zip -y
		apt-get install libxml2 libxml2-dev libfreetype6-dev libjpeg-dev libpng-dev libgtk2.0-dev libssl-dev libxslt-dev libmcrypt-dev libaio-dev -y
		apt-get install git-core gnupg flex bison gperf gcc-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev ccache libgl1-mesa-dev libxml2-utils xsltproc u-boot-tools gawk -y
		apt-get install cpp binutils tar bzip2 libncurses5-dev libncurses5 libevent-dev zlibc libsasl2-dev zlib1g zlib1g-dev libbz2-1.0 libbz2-dev libglib2.0-dev libfreetype6 libpq-dev libpq5 gettext libcap-dev ftp expect -y
		apt-get install less psmisc cpp libxslt1-dev cmake make ntp logrotate m4 patch -y
		apt-get install autoconf re2c cron libpam0g-dev libreadline-gplv2-dev libzip-dev libc6-dev -y
		apt-get install libkrb5-dev libncurses* -y
		apt-get install libltdl7 numactl freetype* golang -y
		apt-get install libonig-dev automake libtool -y
		apt-get install libcurl4-openssl-dev -y
		apt-get install libaio1 libnuma1 libmecab2 -y
		apt-get install libmemcached-dev -y
		apt-get install build-essential -y
		apt-get install quota lftp -y
		apt-get install libtirpc* -y
		apt-get install libpcre* -y
		apt-get install libreadline6-dev -y
		apt-get install freeglut3-dev -y
		apt-get upgrade -y
		dpkg --purge kate
		dpkg --purge kscope
	fi
	#go
	wget --no-check-certificate https://golang.google.cn/dl/$go.linux-amd64.tar.gz
	tar zxvf $go.linux-amd64.tar.gz
	mv go /usr/local/go
	mkdir -p /root/work
	echo 'export PATH=$PATH:/usr/local/go/bin' >>/etc/profile
	echo 'export GOPATH=/root/work' >>/etc/profile
	mv /usr/bin/go /usr/bin/goold
	ln -s /usr/local/go/bin/go /usr/bin/go
	mkdir -p /home/caddy/web
	mkdir -p /home/caddy/etc
	mkdir -p /home/caddy/config
	mkdir -p /home/caddy/port
	#caddyuser
	groupadd --system caddy
	useradd --system --gid caddy --create-home --home-dir /home/caddy/web/ --shell /usr/sbin/nologin --comment "Caddy web server" caddy
}
function InstallFirewall() {
	if grep -i "CentOS" /etc/*-release || grep -i "Rocky" /etc/*-release || grep -i "Alma" /etc/*-release || grep -i "Fedora" /etc/*-release; then
		yum install firewalld -y
		systemctl enable firewalld
		systemctl restart firewalld
		firewall-cmd --add-port=21/tcp --permanent
		firewall-cmd --add-port=22/tcp --permanent
		firewall-cmd --add-port=80/tcp --permanent
		firewall-cmd --add-port=443/tcp --permanent
		firewall-cmd --add-service=ftp --permanent
		firewall-cmd --reload
	else
		apt remove --purge ufw -y
		apt-get install firewalld -y
		sed -i "s/IndividualCalls=no/IndividualCalls=yes/g" /etc/firewalld/firewalld.conf
		systemctl enable firewalld
		systemctl restart firewalld
		firewall-cmd --add-port=21/tcp --permanent
		firewall-cmd --add-port=22/tcp --permanent
		firewall-cmd --add-port=80/tcp --permanent
		firewall-cmd --add-port=443/tcp --permanent
		firewall-cmd --add-service=ftp --permanent
		firewall-cmd --reload
	fi
}
function InstallLibassembly() {
	wget $loshub/linux/libiconv/$libiconv.tar.gz
	tar -zxf $libiconv.tar.gz
	cd $libiconv
	./configure --prefix=/usr/local/libiconv && make -j$Cpunum && make install
	cd .. && rm -rf $libiconv $libiconv.tar.gz
	#libzip
	wget $loshub/linux/libzip/$libzip.tar.gz
	tar -zxvf $libzip.tar.gz
	cd $libzip
	mkdir -p build && cd build
	cmake -DCMAKE_INSTALL_PREFIX=/usr ..
	make -j$Cpunum && make install
	cd .. && cd .. && rm -rf $libzip.tar.gz $libzip
	#autoconf
	wget $loshub/linux/autoconf/$autoconf.tar.gz
	tar -zxf $autoconf.tar.gz
	cd $autoconf
	./configure && make -j$Cpunum && make install
	cd .. && rm -rf $autoconf $autoconf.tar.gz
	\cp /usr/local/bin/autoconf /usr/bin
	\cp /usr/local/bin/autoreconf /usr/bin
	#openss1.0
	wget $loshub/linux/openssl/$openssl.tar.gz
	tar -zxf $openssl.tar.gz
	cd $openssl
	./config -fPIC --prefix=/usr/local/openssl102u && make -j$Cpunum && make install
	cd .. && rm -rf $openssl $openssl.tar.gz
	#openssl1.1
	wget $loshub/linux/openssl/$openssl11.tar.gz
	tar -zxf $openssl11.tar.gz
	cd $openssl11
	./config -fPIC --prefix=/usr/local/openssl11 && make -j$Cpunum && make install
	cd .. && rm -rf $openssl11 $openssl11.tar.gz
	#curl
	wget $loshub/linux/curl/$curl.tar.gz
	tar -zxf $curl.tar.gz
	cd $curl
	./configure --prefix=/usr/local/curl --with-ssl=/usr/local/openssl102u && make -j$Cpunum && make install
	cd .. && rm -rf $curl $curl.tar.gz
	#freetype
	wget $loshub/linux/freetype/$freetype.tar.gz
	tar -zxf $freetype.tar.gz
	cd $freetype
	./configure --prefix=/usr/local/freetype && make -j$Cpunum && make install
	cd .. && rm -rf $freetype && tar zxf $freetype.tar.gz
	cd $freetype
	./configure --enable-static --enable-shared
	make -j$Cpunum && make install
	cd .. && rm -rf $freetype $freetype.tar.gz
	#pcre2
	wget $loshub/linux/pcre/pcre2-10.39.tar.gz
	tar zxf pcre2-10.39.tar.gz
	cd pcre2-10.39
	./configure && make -j$Cpunum && make install
	cd .. && rm -rf pcre2-10.39 pcre2-10.39.tar.gz
	#oniguruma
	wget $loshub/linux/oniguruma/$oniguruma.tar.gz
	tar -zxf $oniguruma.tar.gz
	cd $oniguruma
	autoreconf -vfi && ./configure
	make -j$Cpunum && make install
	cd .. && rm -rf $oniguruma $oniguruma.tar.gz
	#libgd
	wget $loshub/linux/gd/gd-$libgd.tar.gz
	tar zxf gd-$libgd.tar.gz
	cd libgd-gd-$libgd
	./bootstrap.sh
	./configure --with-png --with-freetype --with-jpeg
	make -j$Cpunum && make install
	cd .. && rm -rf gd-$libgd.tar.gz libgd-gd-$libgd
}
function Installopenssl() {
	wget $loshub/linux/openssl/$openssl11.tar.gz
	tar -zxf $openssl11.tar.gz
	cd $openssl11
	./config -zlib enable-shared -fPIC && make -j$Cpunum && make install
	cd .. && rm -rf $openssl11 $openssl11.tar.gz
	mv /usr/bin/openssl /usr/bin/openssl.old
	ln -s /usr/local/bin/openssl /usr/bin/openssl
	mv /usr/bin/openssl /usr/bin/openssl.old
	ln -s /usr/local/bin/openssl /usr/bin/openssl
	if grep -i "CentOS" /etc/*-release || grep -i "Rocky" /etc/*-release || grep -i "Alma" /etc/*-release || grep -i "Fedora" /etc/*-release; then
		if grep 7.* /etc/*-release | grep -i "CentOS"; then
			ln -s /usr/local/include/openssl/ /usr/include/openssl
			rm -rf /usr/lib64/libcrypto.so.1.1
			ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
			rm -rf /usr/lib64/libcrypto.so
			ln -s /usr/local/lib64/libcrypto.so /usr/lib64/libcrypto.so
			rm -rf /usr/lib64/libssl.so
			ln -s /usr/local/lib64/libssl.so /usr/lib64/libssl.so
			rm -rf /usr/lib64/libssl.so.1.1
			ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
			rm -rf /usr/lib64/pkgconfig/openssl.pc
			cp -rf /usr/local/lib64/pkgconfig/openssl.pc /usr/lib64/pkgconfig
		fi
	else
		ln -s /usr/local/include/openssl/ /usr/include/openssl
		rm -rf /usr/lib64/libcrypto.so.1.1
		ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1
		rm -rf /usr/lib64/libcrypto.so
		ln -s /usr/local/lib64/libcrypto.so /usr/lib64/libcrypto.so
		rm -rf /usr/lib64/libssl.so
		ln -s /usr/local/lib64/libssl.so /usr/lib64/libssl.so
		rm -rf /usr/lib64/libssl.so.1.1
		ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
		rm -rf /usr/lib64/pkgconfig/openssl.pc
		cp -rf /usr/local/lib64/pkgconfig/openssl.pc /usr/lib64/pkgconfig
	fi
}
function InstallMysql55() {
	if [ "$confirm" == '1' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget $loshub/linux/mysql/mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
		tar -zxf mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
		rm -rf mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz
		mv -f mysql-5.5.62-linux-glibc2.12-x86_64 /usr/local/mysql
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    user = mysql
    socket = /tmp/mysql.sock
    basedir = /usr/local/mysql
    datadir = /home/mysql/data
    pid-file = /home/mysql/data/mysql.pid
    log-error = /home/mysql/data/error.log
    max_connections = 500
    thread_cache_size = 10
    default-storage-engine = MyISAM
    innodb = OFF
    skip-innodb
    port = 3306
    socket = /tmp/mysql.sock
    skip-external-locking
    key_buffer_size = 16M
    max_allowed_packet = 20M
    table_open_cache = 256
    table_definition_cache = 400
    sort_buffer_size = 512K
    net_buffer_length = 8K
    read_buffer_size = 256K
    read_rnd_buffer_size = 512K
    myisam_sort_buffer_size = 8M
    log-bin = mysql-bin
    binlog_format = mixed
    server-id = 1

    [mysqldump]
    quick

    [mysql]
    no-auto-rehash

    [myisamchk]
    key_buffer_size = 20M
    sort_buffer_size = 20M
    read_buffer = 2M
    write_buffer = 2M

    [mysqlhotcopy]
    interactive-timeout
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql/ --datadir=/home/mysql/data/ --defaults-file=/etc/my.cnf
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
		echo "[OK] ${Mysql55Version} install completed."
	fi
}

function InstallMysql56() {
	if [ "$confirm" == '2' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget $loshub/linux/mysql/mysql-5.6.51-linux-glibc2.12-x86_64.tar.gz
		tar -zxf mysql-5.6.51-linux-glibc2.12-x86_64.tar.gz
		rm -rf mysql-5.6.51-linux-glibc2.12-x86_64.tar.gz
		mv -f mysql-5.6.51-linux-glibc2.12-x86_64 /usr/local/mysql
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    basedir = /usr/local/mysql
    datadir = /home/mysql/data
    pid-file = /home/mysql/data/mysql.pid
    log-error = /home/mysql/data/error.log
    user = mysql
    skip-external-locking
    key_buffer_size = 16M
    max_allowed_packet = 1M
    table_open_cache = 256
    sort_buffer_size = 512K
    net_buffer_length = 8K
    read_buffer_size = 256K
    read_rnd_buffer_size = 512K
    myisam_sort_buffer_size = 8M
    thread_cache_size = 8
    query_cache_size = 8M
    tmp_table_size = 16M
    performance_schema_max_table_instances = 500
    explicit_defaults_for_timestamp = true
    max_connections = 500
    max_connect_errors = 100
    open_files_limit = 65535
    table_definition_cache = 400
    log-bin=mysql-bin
    binlog_format=mixed
    server-id   = 1
    expire_logs_days = 10

    default_storage_engine = InnoDB

    [mysqldump]
    quick
    max_allowed_packet = 16M

    [mysql]
    no-auto-rehash

    [myisamchk]
    key_buffer_size = 20M
    sort_buffer_size = 20M
    read_buffer = 2M
    write_buffer = 2M

    [mysqlhotcopy]
    interactive-timeout
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --user=mysql --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/home/mysql/data
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
		echo "[OK] ${Mysql55Version} install completed."
	fi
}
function Installmysql57() {
	if [ "$confirm" == '3' ]; then
		groupadd -r mysql && useradd -g mysql -r -M -s /sbin/nologin mysql
		mkdir -p /home/mysql/data
		wget $loshub/linux/rpcsvc-proto/rpcsvc-proto-1.4.2.tar.xz
		tar -Jxvf rpcsvc-proto-1.4.2.tar.xz
		cd rpcsvc-proto-1.4.2
		./configure && make -j$Cpunum && make install
		cd .. && rm -rf rpcsvc-proto-1.4.2 rpcsvc-proto-1.4.2.tar.xz
		wget --no-check-certificate https://cdn.mysql.com/archives/mysql-5.7/mysql-5.7.37-linux-glibc2.12-x86_64.tar.gz
		tar zxf mysql-5.7.37-linux-glibc2.12-x86_64.tar.gz
		rm -rf mysql-5.7.37-linux-glibc2.12-x86_64.tar.gz
		mv -f mysql-5.7.37-linux-glibc2.12-x86_64 /usr/local/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock
    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    user = mysql
    basedir = /usr/local/mysql
    datadir = /home/mysql/data
    pid-file = /home/mysql/data/mysql.pid
    log_error = /home/mysql/data/mysql-error.log
    slow_query_log = 1
    long_query_time = 1
    slow_query_log_file = /home/mysql/data/mysql-slow.log
    skip-external-locking
    key_buffer_size = 32M
    max_allowed_packet = 1024M
    table_open_cache = 256
    sort_buffer_size = 768K
    net_buffer_length = 8K
    table_definition_cache = 400
    read_buffer_size = 768K
    read_rnd_buffer_size = 512K
    myisam_sort_buffer_size = 8M
    thread_cache_size = 16
    query_cache_size = 16M
    tmp_table_size = 32M
    performance_schema_max_table_instances = 500
    explicit_defaults_for_timestamp = true
    max_connections = 500
    max_connect_errors = 100
    open_files_limit = 65535
    log_bin=mysql-bin
    binlog_format=mixed
    server_id   = 232
    expire_logs_days = 10
    early-plugin-load = ""
    default_storage_engine = InnoDB
    innodb_file_per_table = 1
    innodb_buffer_pool_size = 128M
    innodb_log_file_size = 32M
    innodb_log_buffer_size = 8M
    innodb_flush_log_at_trx_commit = 1
    innodb_lock_wait_timeout = 50
    [mysqldump]
    quick
    max_allowed_packet = 16M
    [mysql]
    no-auto-rehash
    [myisamchk]
    key_buffer_size = 32M
    sort_buffer_size = 768K
    read_buffer = 2M
    write_buffer = 2M
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        chown -R mysql:mysql /usr/local/mysql
		chown -R mysql:mysql /home/mysql/data
		/usr/local/mysql/bin/mysqld --initialize-insecure --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysql/data
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
		echo "[OK] ${Mysql55Version} install completed."
	fi
}
function InstallMariadb101() {
	if [ "$confirm" == '4' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget --no-check-certificate https://archive.mariadb.org//mariadb-10.1.48/bintar-linux-glibc_214-x86_64/mariadb-10.1.48-linux-glibc_214-x86_64.tar.gz
		tar zxf mariadb-10.1.48-linux-glibc_214-x86_64.tar.gz
		rm -rf mariadb-10.1.48-linux-glibc_214-x86_64.tar.gz
		mv -f mariadb-10.1.48-linux-glibc_214-x86_64 /usr/local/mysql
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    datadir = /home/mysql/data
    skip-external-locking
    back_log = 50
    max_connections = 500
    max_connect_errors = 1000
    open_files_limit = 16384
    max_allowed_packet = 16M
    read_buffer_size = 8M
    read_rnd_buffer_size = 32M
    sort_buffer_size = 2M
    join_buffer_size = 2M
    thread_cache_size = 64
    query_cache_size = 64M
    table_definition_cache = 400
    query_cache_limit = 4M
    slow_query_log = 1
    long_query_time = 2
    lower_case_table_names = 1
    innodb_file_per_table = 1
    max_allowed_packet = 1G
    table_open_cache = 256
    server-id = 1
    log-bin = mysql-bin
    expire_logs_days = 7
    binlog_format = ROW
    performance_schema_max_table_instances = 500
    innodb_data_file_path = ibdata1:12M:autoextend
    innodb_buffer_pool_size = 2G
    innodb_write_io_threads = 12
    innodb_read_io_threads = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 16M
    innodb_log_file_size = 170M
    innodb_lock_wait_timeout = 60
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/home/mysql/data/ --user=mysql
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
	fi
}
function InstallMariadb102() {
	if [ "$confirm" == '5' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget --no-check-certificate https://archive.mariadb.org//$mariadb102/bintar-linux-glibc_214-x86_64/$mariadb102-linux-glibc_214-x86_64.tar.gz
		tar zxf $mariadb102-linux-glibc_214-x86_64.tar.gz
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		touch /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    datadir = /home/mysql/data
    skip-external-locking
    back_log = 50
    max_connections = 500
    max_connect_errors = 1000
    open_files_limit = 16384
    max_allowed_packet = 16M
    read_buffer_size = 8M
    read_rnd_buffer_size = 32M
    performance_schema_max_table_instances = 500
    sort_buffer_size = 2M
    join_buffer_size = 2M
    thread_cache_size = 64
    query_cache_size = 64M
    table_definition_cache = 400
    query_cache_limit = 4M
    slow_query_log = 1
    long_query_time = 2
    lower_case_table_names = 1
    innodb_file_per_table = 1
    max_allowed_packet = 1G
    server-id = 1
    log-bin = mysql-bin
    expire_logs_days = 7
    binlog_format = ROW
    table_open_cache = 256
    innodb_data_file_path = ibdata1:12M:autoextend
    innodb_buffer_pool_size = 2G
    innodb_write_io_threads = 12
    innodb_read_io_threads = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 16M
    innodb_log_file_size = 170M
    innodb_lock_wait_timeout = 60
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/home/mysql/data/ --user=mysql
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
	fi
}
function InstallMariadb103() {
	if [ "$confirm" == '6' ]; then
		groupadd mysql -g 5001
		useradd -s /sbin/nologin mysql -u 5001 -g 5001
		wget --no-check-certificate https://archive.mariadb.org/$mariadb103/bintar-linux-glibc_214-x86_64/$mariadb103-linux-glibc_214-x86_64.tar.gz
		tar zxf $mariadb103-linux-glibc_214-x86_64.tar.gz
		rm -rf $mariadb103-linux-glibc_214-x86_64.tar.gz
		mv -f $mariadb103-linux-glibc_214-x86_64 /usr/local/mysql
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		touch /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    datadir = /home/mysql/data
    skip-external-locking
    back_log = 50
    max_connections = 500
    max_connect_errors = 1000
    open_files_limit = 16384
    max_allowed_packet = 16M
    read_buffer_size = 8M
    read_rnd_buffer_size = 32M
    performance_schema_max_table_instances = 500
    sort_buffer_size = 2M
    join_buffer_size = 2M
    thread_cache_size = 64
    query_cache_size = 64M
    table_definition_cache = 400
    query_cache_limit = 4M
    slow_query_log = 1
    long_query_time = 2
    lower_case_table_names = 1
    innodb_file_per_table = 1
    max_allowed_packet = 1G
    server-id = 1
    log-bin = mysql-bin
    expire_logs_days = 7
    binlog_format = ROW
    table_open_cache = 256
    innodb_data_file_path = ibdata1:12M:autoextend
    innodb_buffer_pool_size = 2G
    innodb_write_io_threads = 12
    innodb_read_io_threads = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 16M
    innodb_log_file_size = 170M
    innodb_lock_wait_timeout = 60
    character-set-server=utf8
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/home/mysql/data/ --user=mysql
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
	fi
}
function InstallMariadb104() {
	if [ "$confirm" == '7' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget --no-check-certificate https://archive.mariadb.org/$mariadb104/bintar-linux-glibc_214-x86_64/$mariadb104-linux-glibc_214-x86_64.tar.gz
		tar zxf $mariadb104-linux-glibc_214-x86_64.tar.gz
		rm -rf $mariadb104-linux-glibc_214-x86_64.tar.gz
		mv $mariadb104-linux-glibc_214-x86_64 /usr/local/mysql
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    datadir = /home/mysql/data
    skip-external-locking
    back_log = 50
    max_connections = 500
    max_connect_errors = 1000
    open_files_limit = 16384
    max_allowed_packet = 16M
    read_buffer_size = 8M
    read_rnd_buffer_size = 32M
    performance_schema_max_table_instances = 500
    sort_buffer_size = 2M
    join_buffer_size = 2M
    thread_cache_size = 64
    query_cache_size = 64M
    table_definition_cache = 400
    query_cache_limit = 4M
    slow_query_log = 1
    long_query_time = 2
    lower_case_table_names = 1
    innodb_file_per_table = 1
    max_allowed_packet = 1G
    server-id = 1
    log-bin = mysql-bin
    expire_logs_days = 7
    binlog_format = ROW
    table_open_cache = 256
    innodb_data_file_path = ibdata1:12M:autoextend
    innodb_buffer_pool_size = 2G
    innodb_write_io_threads = 12
    innodb_read_io_threads = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 16M
    innodb_log_file_size = 170M
    innodb_lock_wait_timeout = 60
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/home/mysql/data/ --user=mysql
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
		touch /lib/systemd/system/mysql.service
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
	fi
}
function InstallMariadb105() {
	if [ "$confirm" == '8' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget --no-check-certificate https://archive.mariadb.org/$mariadb105/bintar-linux-glibc_214-x86_64/$mariadb105-linux-glibc_214-x86_64.tar.gz
		tar -zxf $mariadb105-linux-x86_64.tar.gz
		rm -rf $mariadb105-linux-x86_64.tar.gz
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [client]
    port = 3306
    socket = /tmp/mysql.sock

    [mysqld]
    port = 3306
    socket = /tmp/mysql.sock
    datadir = /home/mysql/data
    skip-external-locking
    back_log = 50
    max_connections = 500
    max_connect_errors = 1000
    table_open_cache = 256
    open_files_limit = 16384
    max_allowed_packet = 16M
    read_buffer_size = 8M
    read_rnd_buffer_size = 32M
    sort_buffer_size = 2M
    join_buffer_size = 2M
    thread_cache_size = 64
    query_cache_size = 64M
    query_cache_limit = 4M
    slow_query_log = 1
    long_query_time = 2
    lower_case_table_names = 1
    innodb_file_per_table = 1
    max_allowed_packet = 1G
    table_definition_cache = 400
    server-id = 1
    log-bin = mysql-bin
    expire_logs_days = 7
    binlog_format = ROW
    performance_schema_max_table_instances = 500
    innodb_data_file_path = ibdata1:12M:autoextend
    innodb_buffer_pool_size = 2G
    innodb_write_io_threads = 12
    innodb_read_io_threads = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 16M
    innodb_log_file_size = 170M
    innodb_lock_wait_timeout = 60
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysql/data
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		/usr/local/mysql/bin/mysqladmin password $MysqlPass
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
	fi
}
function Installmysql80() {
	if [ "$confirm" == '9' ]; then
		groupadd mysql
		useradd -s /sbin/nologin -g mysql mysql
		wget $loshub/linux/mysql/mysql-$mysql80-linux-glibc2.17-x86_64-minimal.tar.xz
		tar -xf mysql-$mysql80-linux-glibc2.17-x86_64-minimal.tar.xz
		mv -f mysql-$mysql80-linux-glibc2.17-x86_64-minimal /usr/local/mysql
		rm -rf mysql-$mysql80-linux-glibc2.17-x86_64-minimal.tar.xz
		mkdir -p /home/mysql/data
		chown -R mysql:mysql /home/mysql
		rm -rf /etc/my.cnf
cat >>/etc/my.cnf <<EOF
    [mysqld]
    user=mysql
    datadir=/home/mysql/data
    basedir=/usr/local/mysql
    port=3306
    max_connections=200
    max_connect_errors=10
    character-set-server=utf8
    default-storage-engine=INNODB
    default_authentication_plugin=mysql_native_password
    lower_case_table_names=1
    group_concat_max_len=102400
    max_connections = 500
    max_connect_errors = 1000
    table_open_cache = 256
    open_files_limit = 16384
    max_allowed_packet = 16M
    read_buffer_size = 8M
    read_rnd_buffer_size = 32M
    sort_buffer_size = 2M
    join_buffer_size = 2M
    thread_cache_size = 64
    slow_query_log = 1
    long_query_time = 2
    lower_case_table_names = 1
    innodb_file_per_table = 1
    max_allowed_packet = 1G
    table_definition_cache = 400
    server-id = 1
    log-bin = mysql-bin
    expire_logs_days = 7
    binlog_format = ROW
    performance_schema_max_table_instances = 500
    innodb_data_file_path = ibdata1:12M:autoextend
    innodb_buffer_pool_size = 2G
    innodb_write_io_threads = 12
    innodb_read_io_threads = 8
    innodb_flush_log_at_trx_commit = 2
    innodb_log_buffer_size = 16M
    innodb_log_file_size = 170M
    innodb_lock_wait_timeout = 60
    [mysql]
    default-character-set=utf8
    [client]
    port=3306
    default-character-set=utf8
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /etc/my.cnf
        /usr/local/mysql/bin/mysqld --user=mysql --basedir=/usr/local/mysql --datadir=/home/mysql/data --initialize 2>&1 | tee /root/mysqlps.log
		chmod 775 /usr/local/mysql/support-files/mysql.server
		/usr/local/mysql/support-files/mysql.server start
		#处理密码问题
		grep "password" /root/mysqlps.log 2>&1 | tee /root/ps.log
		MysqlPss=$(cat /root/ps.log | cut -d @ -f 2 | cut -d " " -f 2)
		rm -rf /root/mysqlps.log /root/ps.log
		ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
		ln -s /usr/local/mysql/bin/mysqladmin /usr/bin/mysqladmin
		ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
		ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
		ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
		rm -rf /usr/local/mysql/data/test
		mysql -uroot -p$MysqlPss --connect-expired-password <<EOF
alter user 'root'@'localhost' identified by '$MysqlPass';
EOF
cat >>/lib/systemd/system/mysql.service <<EOF
    [Unit]
    Description=mysql server Service
    After=syslog.target network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/mysql/support-files/mysql.server start
    ExecReload=/usr/local/mysql/support-files/mysql.server restart
    ExecStop=/usr/local/mysql/support-files/mysql.server stop

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/mysql.service
        ln -s /lib/systemd/system/mysql.service /etc/systemd/system/multi-user.target.wants/mysql
		systemctl daemon-reload
		systemctl enable mysql
	fi
}
function InstallPhp74() {
	wget $loshub/linux/php/$Php74.tar.gz
	tar -zxf $Php74.tar.gz
	cd $Php74
	./configure --prefix=/usr/local/php/php74 --with-config-file-path=/usr/local/php/php74/etc --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-fpm --with-fpm-user=caddy --with-fpm-group=caddy --with-freetype=/usr/local/freetype --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gettext --enable-mbstring --with-mhash --with-openssl=/usr/local/openssl11 --enable-bcmath --enable-soap --with-libxml --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-zlib --enable-zip --with-bz2 --with-readline --with-iconv --enable-opcache $fileinfo --enable-gd --with-png --with-jpeg --enable-gd-native-ttf --enable-ftp --enable-mbregex --with-xmlrpc
	make -j$Cpunum && make install
	cp php.ini-development /usr/local/php/php74/etc/php.ini
	cd .. && rm -rf $Php74 $Php74.tar.gz
	mv /usr/local/php/php74/etc/php-fpm.d/www.conf.default /usr/local/php/php74/etc/php-fpm.d/www.conf
	sed -i "s#9000#9074#g" /usr/local/php/php74/etc/php-fpm.d/www.conf
	sed -i 's/disable_functions =/disable_functions=eval,passthru,exec,system,chroot,scandir,chgrp,chown,shell_exec,proc_open,proc_get_status,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,popepassthru,stream_socket_server,disk_total_space,disk_free_space,error_log,putenv,popen,ini_set,chmod,assert,pcntl_exec,phpfunc;/' /usr/local/php/php74/etc/php.ini
	sed -i 's#;user_ini.filename = ".user.ini"#user_ini.filename = ".user.ini"#' /usr/local/php/php74/etc/php.ini
	cp /usr/local/php/php74/etc/php-fpm.conf.default /usr/local/php/php74/etc/php-fpm.conf
	mv /usr/local/php/php74/etc/php-fpm.d/www.conf.default /usr/local/php/php74/etc/php-fpm.d/www.conf
	sed -i "s#9000#9074#g" /usr/local/php/php74/etc/php-fpm.d/www.conf
	sed -i "s#;pid#pid#g" /usr/local/php/php74/etc/php-fpm.conf
	sed -i "s:run/php-fpm.pid:/var/run/php-fpm7.4.pid:g" /usr/local/php/php74/etc/php-fpm.conf
	sed -i 's/post_max_size/;post_max_size/' /usr/local/php/php74/etc/php.ini
	echo 'post_max_size=100M' >>/usr/local/php/php74/etc/php.ini
	sed -i 's/upload_max_filesize/;upload_max_filesize/' /usr/local/php/php74/etc/php.ini
	echo 'upload_max_filesize=100M' >>/usr/local/php/php74/etc/php.ini
	sed -i 's/max_execution_time/;max_execution_time/' /usr/local/php/php74/etc/php.ini
	echo 'max_execution_time=300' >>/usr/local/php/php74/etc/php.ini
	#opcache
	echo 'zend_extension = opcache.so' >>/usr/local/php/php74/etc/php.ini
	echo 'opcache.enable=1' >>/usr/local/php/php74/etc/php.ini
	echo 'opcache.memory_consumption = 128' >>/usr/local/php/php74/etc/php.ini
	echo 'opcache.interned_strings_buffer = 8' >>/usr/local/php/php74/etc/php.ini
	echo 'opcache.max_accelerated_files = 10000' >>/usr/local/php/php74/etc/php.ini
	echo 'opcache.revalidate_freq = 2' >>/usr/local/php/php74/etc/php.ini
	echo 'opcache.enable_cli = 1' >>/usr/local/php/php74/etc/php.ini
	#apcu
	wget $loshub/linux/apcu/$apcu5.tgz
	tar zxf $apcu5.tgz
	cd $apcu5
	/usr/local/php/php74/bin/phpize
	./configure --with-php-config=/usr/local/php/php74/bin/php-config
	make -j$Cpunum && make install
	echo 'extension="apcu.so"' >>/usr/local/php/php74/etc/php.ini
	cd .. && rm -rf $apcu5 $apcu5.tgz
	touch /lib/systemd/system/php-fpm74.service
cat >>/lib/systemd/system/php-fpm74.service <<\EOF
    [Unit] 
    Description=The PHP FastCGI Process Manager 
    After=syslog.target network.target 

    [Service]
    Type=forking
    PIDFile=/var/run/php-fpm7.4.pid
    ExecStart=/usr/local/php/php74/sbin/php-fpm
    ExecReload=/bin/kill -USR2 $MAINPID
    PrivateTmp=true

    [Install] 
    WantedBy=multi-user.target
EOF
	# 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /lib/systemd/system/php-fpm74.service
    ln -s /lib/systemd/system/php-fpm74.service /etc/systemd/system/multi-user.target.wants/php-fpm74
	systemctl daemon-reload && systemctl enable php-fpm74
}
function InstallCaddy() {
	# 卸载caddy
	if [ "$(which caddy)" ]; then
		systemctl disable caddy 
		systemctl stop caddy 
		sudo rm -f /etc/apt/sources.list.d/caddy-stable.list 
		rm -f /etc/caddy/Caddyfile 
		sudo apt remove caddy -y 
	fi
	wget $loshub/linux/caddy/$caddy.tar.gz
	tar zxf $caddy.tar.gz
	cd $caddy/cmd/caddy/
	go build
	mv caddy /usr/bin/
	cd -
	rm -rf $caddy $caddy.tar.gz
	mkdir -p /home/caddy/etc/vhosts
	mkdir -p /home/caddy/etc/proxy
cat >>/home/caddy/etc/Caddyfile <<EOF
    import ./vhosts/*
    import ./proxy/*
EOF
	# 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /home/caddy/etc/Caddyfile
    chown -R caddy:caddy /home/caddy
	mkdir -p /etc/ssl/caddy
	chown -R root:caddy /etc/ssl/caddy
	chmod 0770 /etc/ssl/caddy
	mkdir -p /var/log/caddy
	chown -R caddy:root /var/log/caddy
	touch /lib/systemd/system/caddy.service
cat >>/lib/systemd/system/caddy.service <<EOF
    [Unit]
    Description=Caddy
    Documentation=https://caddyserver.com/docs/
    After=network.target network-online.target
    Requires=network-online.target

    [Service]
    User=caddy
    Group=caddy
    ExecStart=/usr/bin/caddy run --environ --config /home/caddy/etc/Caddyfile
    ExecReload=/usr/bin/caddy reload --config /home/caddy/etc/Caddyfile
    TimeoutStopSec=5s
    LimitNOFILE=1048576
    LimitNPROC=512
    PrivateTmp=true
    ProtectSystem=full
    AmbientCapabilities=CAP_NET_BIND_SERVICE

    [Install]
    WantedBy=multi-user.target
EOF
	# 格式化文件（删除每一行首多余空格）
    sed -i 's/^[ \t]...//g' /lib/systemd/system/caddy.service
    ln -s /lib/systemd/system/caddy.service /etc/systemd/system/multi-user.target.wants/caddy
	systemctl daemon-reload
	systemctl enable caddy
}
function InstallPureFTPd() {
	if [ "$ftpinstall" == '1' ]; then
		wget $loshub/linux/pureftpd/$pureftp.tar.gz
		tar zxvf $pureftp.tar.gz
		cd $pureftp
		./configure --prefix=/usr/local/pureftpd CFLAGS=-O2 --with-puredb --with-quotas --with-cookie --with-virtualhosts --with-diraliases --with-sysquotas --with-ratios --with-altlog --with-paranoidmsg --with-shadow --with-welcomemsg --with-throttling --with-uploadscript --with-language=english --with-rfc2640 --with-ftpwho --with-tls=/usr/local/openssl102u
		make -j$Cpunum && make install
		cd .. && rm -rf $pureftp $pureftp.tar.gz
		echo "export PATH=$PATH:/usr/local/pureftpd/sbin:/usr/local/pureftpd/bin" >/etc/profile.d/pureftpd.sh
		source /etc/profile
		touch /usr/local/pureftpd/etc/pureftpd.passwd
		touch /usr/local/pureftpd/etc/pureftpd.pdb
		rm -rf /usr/local/pureftpd/etc/pure-ftpd.conf
		touch /usr/local/pureftpd/etc/pure-ftpd.conf
cat >>/usr/local/pureftpd/etc/pure-ftpd.conf <<EOF
    chrootEveryone               yes
    BrokenClientsCompatibility   no
    MaxClientsNumber             50
    Daemonize                    yes
    MaxClientsPerIP              10
    VerboseLog                   no
    DisplayDotFiles              yes
    AnonymousOnly                no
    NoAnonymous                  yes
    SyslogFacility               ftp
    DontResolve                  yes
    MaxIdleTime                  15
    PureDB                       /usr/local/pureftpd/etc/pureftpd.pdb
    LimitRecursion               10000 8
    AnonymousCanCreateDirs       no
    MaxLoad                      4
    PassivePortRange             3500 4000
    #ForcePassiveIP               $Domain
    AntiWarez                    yes
    Bind                         ,21
    Umask                        133:022
    MinUID                       100
    AllowUserFXP                 no
    AllowAnonymousFXP            no
    ProhibitDotFilesWrite        no
    ProhibitDotFilesRead         no
    AutoRename                   no
    AnonymousCantUpload          yes
    PIDFile                      /var/run/pure-ftpd.pid
    MaxDiskUsage                   99
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /usr/local/pureftpd/etc/pure-ftpd.conf
        touch /lib/systemd/system/pureftp.service
cat >>/lib/systemd/system/pureftp.service <<EOF
    [Unit]
    Description=ftp Service
    After=syslog.target network.target

    [Service]
    Type=forking
    PIDFile=/var/run/pure-ftpd.pid
    ExecStart=/usr/local/pureftpd/sbin/pure-ftpd /usr/local/pureftpd/etc/pure-ftpd.conf
    ExecReload=/bin/kill -USR1 $MAINPID

    [Install]
    WantedBy=multi-user.target
EOF
		# 格式化文件（删除每一行首多余空格）
        sed -i 's/^[ \t]...//g' /lib/systemd/system/pureftp.service
        ln -s /lib/systemd/system/pureftp.service /etc/systemd/system/multi-user.target.wants/pureftp
		systemctl daemon-reload && systemctl enable pureftp
	fi
}
function setuphost() {
	#mysql root passwd
	mkdir -p /home/Lkmp/config
	cat >>/home/Lkmp/config/mysqlrootpw <<EOF
$MysqlPass
EOF
	#tool
	mkdir -p /home/caddy/tool && cd /home/caddy/tool
	wget $loshub/git/caddy/Tool
	wget $loshub/git/caddy/zjTool
	chmod +x Tool zjTool
	echo 'export PATH=/home/caddy/tool:$PATH ' >>/etc/profile
	source /etc/profile
	systemctl restart php-fpm74
	systemctl start pureftp
	systemctl restart caddy
}
CheckSystem
ConfirmInstall
installftp
Installyum
#InstallFirewall;    #oneking
InstallLibassembly
Installopenssl
InstallMysql55
InstallMysql56
InstallMariadb105
InstallMariadb102
InstallMariadb101
Installmysql57
Installmysql80
InstallCaddy
Installphp74
InstallPureFTPd
setuphost
