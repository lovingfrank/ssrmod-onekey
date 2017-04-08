#!/bin/sh

echo '#############################################
##################参数配置###################
###############这里做基本配置################
#####请将脚本放入shadowsocks根目录下执行#####
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

elif [ "$pd" == "2" ] ; then
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
echo "请输入你的节点ID:"
read nodeid
echo "自动封禁SS密码和加密方式错误的 IP，1为开启，0为关闭:"
read ANTISSATTACK
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
fi

echo "配置完成，重新启动后端生效，Enjoy it！"
echo "需要修改参数时可再次执行此脚本"
echo "制作人：Matt QQ：6637456"
