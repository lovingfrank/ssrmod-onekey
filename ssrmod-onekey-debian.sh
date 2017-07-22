#!/bin/sh
echo '#############################################
############欢迎使用SSR便捷安装包############
#########此脚本只在Debian下通过测试##########
###############感谢glzjin！##################'
echo -e "\033[33m 确认安装请按Y： \033[0m"
read con
if [ "$con" == "Y" ] ; then
cd /root
apt-get update
apt-get install -y build-essential 
apt-get install -y python-pip
apt-get install -y git
echo -e \\n
echo -e \\n

echo ' ########开始安装libsodium#########'
apt-get install build-essential
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
ldconfig

echo -e \\n

echo ' ##########开始安装cymysql###########'
pip install cymysql
apt-get install -y python-devel
apt-get install -y libffi-devel
apt-get install -y openssl-devel
echo ' ##########开始安装魔改后端###########'
cd /root
git clone -b manyuser https://github.com/glzjin/shadowsocks.git
cd shadowsocks
fi

echo '#############################################
#############开始进行参数配置################
##############这里做基本配置#################
#############################################'

echo "按<1>使用glzjinmod，按<2>使用modwebapi，其他键退出:"
read pd
if [ "$pd" == "1" ] ; then
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
echo "请输入你的节点ID:"
read nodeid
echo "自动封禁SS密码和加密方式错误的 IP，1为开启，0为关闭:"
read ANTISSATTACK
echo "是否开启详细日志，1为开启，0为关闭:"
read connect_verbose_info
echo "请输入你的混淆参数:"
read suffix
echo "请输入你的Mysql地址:"
read ip
echo "请输入你的Mysql用户名:"
read user
echo "请输入你的Mysql密码:"
read pwd
echo "请输入你的Mysql数据库名:"
read dbname
sed -i '/NODE_ID/d' userapiconfig.py
sed -i '1a NODE_ID = '$nodeid'' userapiconfig.py
sed -i '/ANTISSATTACK/d' userapiconfig.py
sed -i '7a ANTISSATTACK = '$ANTISSATTACK'' userapiconfig.py
sed -i '/MU_SUFFIX/d' userapiconfig.py
sed -i "10a MU_SUFFIX = '$suffix'" userapiconfig.py
sed -i '/API_INTERFACE/d' userapiconfig.py
sed -i "14a API_INTERFACE = 'glzjinmod'" userapiconfig.py
sed -i '/MYSQL_HOST/d' userapiconfig.py
sed -i "23a MYSQL_HOST = '$ip'" userapiconfig.py
sed -i '/MYSQL_USER/d' userapiconfig.py
sed -i "25a MYSQL_USER = '$user'" userapiconfig.py
sed -i '/MYSQL_PASS/d' userapiconfig.py
sed -i "26a MYSQL_PASS = '$pwd'" userapiconfig.py
sed -i '/MYSQL_DB/d' userapiconfig.py
sed -i "27a MYSQL_DB = '$dbname'" userapiconfig.py
sed -i '/connect_verbose_info/d' user-config.json
sed -i "18a \    \"connect_verbose_info\": $connect_verbose_info\," user-config.json

elif [ "$pd" == "2" ] ; then
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
echo "请输入你的节点ID:"
read nodeid
echo "自动封禁SS密码和加密方式错误的 IP，1为开启，0为关闭:"
read ANTISSATTACK
echo "是否开启详细日志，1为开启，0为关闭:"
read connect_verbose_info
echo "请输入你的混淆参数:"
read suffix
echo "请输入你的webapi地址:"
read apiurl
echo "请输入你的webapi token:"
read apitoken
sed -i '/NODE_ID/d' userapiconfig.py
sed -i '1a NODE_ID = '$nodeid'' userapiconfig.py
sed -i '/ANTISSATTACK/d' userapiconfig.py
sed -i '7a ANTISSATTACK = '$ANTISSATTACK'' userapiconfig.py
sed -i '/MU_SUFFIX/d' userapiconfig.py
sed -i "10a MU_SUFFIX = '$suffix'" userapiconfig.py
sed -i '/WEBAPI_URL/d' userapiconfig.py
sed -i "16a WEBAPI_URL = '$apiurl'" userapiconfig.py
sed -i '/WEBAPI_TOKEN/d' userapiconfig.py
sed -i "17a WEBAPI_TOKEN = '$apitoken'" userapiconfig.py
sed -i '/connect_verbose_info/d' user-config.json
sed -i "18a \    \"connect_verbose_info\": $connect_verbose_info\," user-config.json
fi

echo ' #########开始安装supervisiord#########'

apt-get install -y supervisor
cd /etc/supervisor/conf.d/
echo "#守护配置文件" >shadowsocks.conf 
sed -i '$a [program:shadowsocks]' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a command=python /root/shadowsocks/server.py' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a user=root' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a autostart=true' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a autorestart=true' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stderr_logfile = /var/log/shadowsocks.log' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stdout_logfile = /var/log/shadowsocks.log' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stderr_logfile_maxbytes=4MB' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stderr_logfile_backups=10' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a startsecs=3' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a ulimit -n 51200' /etc/profile /etc/default/supervisor
sed -i '$a ulimit -Sn 4096' /etc/profile /etc/default/supervisor
sed -i '$a ulimit -Hn 8192' /etc/profile /etc/default/supervisor
service supervisor start
supervisorctl reload
echo "配置完成，Enjoy it！"
echo "查看SS日志命令为supervisorctl tail -f shadowsocks stderr"
echo "重载SS守护命令为supervisorctl reload"
echo "重启SS守护命令为service supervisor restart"
echo "停止SS守护命令为service supervisor stop"
echo "如果SS正常启动后，无法“上网”请检查iptables配置"
echo "制作人：Matt QQ：6637456"
