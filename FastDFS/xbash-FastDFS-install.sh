#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

project_name="xbash-FastDFS 1.0";

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install $project_name" 
    exit 1
fi

clear
echo "========================================================================="
echo "$project_name for CentOS/RadHat Written by funfly, Email:funfly@xbash.cn"
echo "========================================================================="
echo "A tool to auto-compile & install FastDFS on Linux "
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

yum -y install wget make gcc gcc-c++ g77 perl libevent libevent-devel

#Set iptables
/sbin/iptables -I INPUT -p tcp --dport 22122 -j ACCEPT
/etc/rc.d/init.d/iptables save
/etc/init.d/iptables restart

cd $cur_dir
echo "============================check files=================================="
if [ -s FastDFS_v4.06.tar.gz ]; then
    echo "FastDFS_v4.06.tar.gz [found]"
    else
    echo "Error: FastDFS_v4.06.tar.gz not found!!!download now......"
    wget -c http://fastdfs.googlecode.com/files/FastDFS_v4.06.tar.gz
fi

echo "============================FastDFS install=================================="

cd $cur_dir
tar -xvf FastDFS_v4.06.tar.gz
cd FastDFS
./make.sh
./make.sh install

echo "============================config FastDFS=================================="
sed -i 's/\/home\/yuqing/\/data\/fastdfs/g' /etc/fdfs/tracker.conf
sed -i 's/\/home\/yuqing/\/data\/fastdfs/g' /etc/fdfs/storage.conf
sed -i 's/\/home\/yuqing/\/data\/fastdfs/g' /etc/fdfs/client.conf

sed -i 's/tracker_server=192.168.209.121:22122/tracker_server=127.0.0.1:22122/g' /etc/fdfs/storage.conf
sed -i 's/tracker_server=192.168.0.197:22122/tracker_server=127.0.0.1:22122/g' /etc/fdfs/client.conf

mkdir /data
mkdir /data/fastdfs
mkdir /data/fastdfs/fastdfs

if [ ! `grep -l "/usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf"    '/etc/rc.local'` ]; then
    echo "/usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf" >> /etc/rc.local
fi

if [ ! `grep -l "/usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf"    '/etc/rc.local'` ]; then
    echo "/usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf" >> /etc/rc.local
fi

echo "============================start service================================="
/usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf
/usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf

echo "===================================== Check install ==================================="
clear

if [ -s /usr/local/bin/fdfs_trackerd ]; then
    echo "/usr/local/bin/fdfs_trackerd [found]"
    else
    echo "Error: /usr/local/bin/fdfs_trackerd not found!!!"
fi

if [ -s /usr/local/bin/fdfs_storaged ]; then
    echo "/usr/local/bin/fdfs_storaged [found]"
    else
    echo "Error: /usr/local/bin/fdfs_storaged not found!!!"
fi

if [ -s /usr/local/bin/fdfs_trackerd ] && [ -s /usr/local/bin/fdfs_storaged ]; then

echo "Install $project_name completed! enjoy it."
echo "========================================================================="
echo "$project_name for CentOS/RadHat Written by funfly, Email:funfly@xbash.cn"
echo "========================================================================="
echo ""
echo "stop tracker:"
echo "/usr/local/bin/stop.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf "
echo ""
echo "stop storage:"
echo "/usr/local/bin/stop.sh /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf "
echo ""
echo "restart tracker:"
echo "/usr/local/bin/restart.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf "
echo ""
echo "restart tracker:"
echo "/usr/local/bin/restart.sh /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf "
echo ""
echo "For more information please visit http://www.xbash.cn/"
echo ""
echo "========================================================================="
netstat -ntl
else
    echo "Sorry,Failed to install $project_name"
    echo "Please visit http://www.xbash.cn/ feedback errors and logs."
fi
fi
 