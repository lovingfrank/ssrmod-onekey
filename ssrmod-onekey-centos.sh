#!/bin/sh
echo '#############################################
############欢迎使用SSR便捷安装包############
#########此脚本只在Centos下通过测试##########
###############感谢glzjin！##################'
echo '确认安装请按<Y>:'
read con
if [ "$con" == "Y" ] ; then
cd ~
yum install -y wget
yum install -y python-setuptools
yum install -y git

echo ' ##########开始安装pip###########'
wget --no-check-certificate  https://pypi.python.org/packages/11/b6/abcb525026a4be042b486df43905d6893fb04f05aac21c32c638e939e447/pip-9.0.1.tar.gz
tar zxvf pip-9.0.1.tar.gz
cd pip-9.0.1
python setup.py install
echo ' ##########开始安装meld3###########'
cd ~
wget http://pkgs.fedoraproject.org/repo/pkgs/python-meld3/meld3-1.0.2.tar.gz/3ccc78cd79cffd63a751ad7684c02c91/meld3-1.0.2.tar.gz
tar zxvf meld3-1.0.2.tar.gz
cd meld3-1.0.2
python setup.py install
echo ' ########开始安装libsodium#########'
cd ~
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
echo ' ##########开始安装cymysql###########'
pip install cymysql
yum -y install python-devel
yum -y install libffi-devel
yum -y install openssl-devel
echo ' ##########开始安装魔改后端###########'
cd ~
git clone -b manyuser https://github.com/glzjin/shadowsocks.git
cd shadowsocks
pip install -r requirements.txt
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

wget –no-check-certificate https://pypi.python.org/packages/source/s/supervisor/supervisor-3.0.tar.gz
tar -zxvf supervisor-3.0.tar.gz && cd supervisor-3.0
python setup.py install
echo_supervisord_conf > /etc/supervisord.conf
wget https://github.com/lovingfrank/ssrmod-onekey/raw/master/supervisord -O /etc/init.d/supervisord
chmod 755 /etc/init.d/supervisord
chkconfig supervisord on
sed -i '$a [program:shadowsocks]' /etc/supervisord.conf
sed -i '$a command = python server.py' /etc/supervisord.conf
sed -i '$a directory = /root/shadowsocks' /etc/supervisord.conf
sed -i '$a user=root' /etc/supervisord.conf
sed -i '$a autostart=true' /etc/supervisord.conf
sed -i '$a autorestart=true' /etc/supervisord.conf
sed -i '$a stderr_logfile = /var/log/shadowsocks.log' /etc/supervisord.conf
sed -i '$a stdout_logfile = /var/log/shadowsocks.log' /etc/supervisord.conf
sed -i '$a startsecs=3' /etc/supervisord.conf
service supervisord start

echo "配置完成，Enjoy it！"
echo "查看SS日志命令为supervisorctl tail -f shadowsocks stderr"
echo "重启SS守护命令为supervisorctl restart shadowsocks或service supervisord restart"
echo "停止SS守护命令为supervisorctl stop shadowsocks或service supervisord stop"
echo "如果SS正常启动后，无法“上网”请检查iptables配置"
echo "制作人：Matt QQ：6637456"
