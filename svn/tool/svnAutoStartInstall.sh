#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script"
    exit 1
fi

if [ -s /usr/sbin/crond ]; then
  echo "/usr/sbin/crond [found]"
else
  echo "Error: /usr/sbin/crond not found!!!"
  yum -y install vixie-cron crontabs
fi

cur_dir=$(pwd)

echo "============================sh crond install=================================="
cd $cur_dir
cp -fr svnAutoStart.sh /home/tool
cat >>/var/spool/cron/root<<eof
*/5 * * * * /home/tool/svnAutoStart.sh
eof
service crond restart
crontab -l