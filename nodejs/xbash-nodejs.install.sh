#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

project_name="xbash-nodejs 1.0";

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install $project_name" 
    exit 1
fi

clear
echo "========================================================================="
echo "$project_name for CentOS/RadHat Written by funfly, Email:funfly@xbash.cn"
echo "========================================================================="
echo "A tool to auto-compile & install nodejs on Linux "
echo ""
echo "For more information please visit http://www.xbash.cn/"
echo "========================================================================="
cur_dir=$(pwd)

if [ "$1" != "--help" ]; then

get_char()
{
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}
echo ""
echo "Press any key to start..."
char=`get_char`

yum -y install wget make gcc gcc-c++ g77 

#Set iptables
/sbin/iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
/etc/rc.d/init.d/iptables save
/etc/init.d/iptables restart

cd $cur_dir
echo "============================check files=================================="
if [ -s node-v0.10.18.tar.gz ]; then
    echo "node-v0.10.18.tar.gz [found]"
    else
    echo "Error: node-v0.10.18.tar.gz not found!!!download now......"
    wget -c http://nodejs.org/dist/v0.10.18/node-v0.10.18.tar.gz
fi

echo "============================nodejs install=================================="

cd $cur_dir
tar -xvf node-v0.10.18.tar.gz
cd "$cur_dir"/node-v0.10.18
./configure --prefix=/usr/local/nodejs
make
make install

if [ ! `grep -l "/usr/local/nodejs/bin"    '/etc/profile'` ]; then
    echo 'export PATH=$PATH:/usr/local/nodejs/bin' >> /etc/profile  
    source /etc/profile 
fi

echo "============================express install================================="

cd /usr/local/nodejs/lib/node_modules/npm
/usr/local/nodejs/bin/npm install
/usr/local/nodejs/bin/npm install -g express


echo "===================================== Check install ==================================="
clear

if [ -s /usr/local/nodejs/bin/node ]; then
    echo "/usr/local/nodejs/bin/node [found]"
    else
    echo "Error: /usr/local/nodejs/bin/node not found!!!"
fi

if [ -s /usr/local/nodejs/bin/express ]; then
    echo "/usr/local/nodejs/bin/express [found]"
    else
    echo "Error: /usr/local/nodejs/bin/express not found!!!"
fi

if [ -s /usr/local/nodejs/bin/node ] && [ -s /usr/local/nodejs/bin/express ]; then

echo "Install $project_name completed! enjoy it."
echo "========================================================================="
echo "$project_name for CentOS/RadHat Written by funfly, Email:funfly@xbash.cn"
echo "========================================================================="
echo ""
echo "node version:"
/usr/local/nodejs/bin/node -v
echo ""
echo "express version:"
/usr/local/nodejs/bin/express -V
echo ""
echo "For more information please visit http://www.xbash.cn/"
echo ""
echo "========================================================================="

else
    echo "Sorry,Failed to install $project_name"
    echo "Please visit http://www.xbash.cn/ feedback errors and logs."
fi
fi
 