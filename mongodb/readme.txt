

1. 下载、安装 mangodb
   官方下载：http://www.mongodb.org/downloads

   cd /usr/local/src
   wget http://fastdl.mongodb.org/linux/mongodb-linux-i686-2.4.7-rc0.tgz
   tar -xvf mongodb-linux-i686-2.4.7-rc0.tar
   mv mongodb-linux-i686-2.4.7-rc0 /usr/local/mongodb

   if [ ! `grep -l "/usr/local/mongodb/bin"    '/etc/profile'` ]; then
      echo 'export PATH=$PATH:/usr/local/mongodb/bin' >> /etc/profile  
      source /etc/profile 
   fi
   
2. 启动mongodb
   mkdir /usr/local/mongodb/data
   mkdir /usr/local/mongodb/logs
   
   mongod --dbpath=/usr/local/mongodb/data --logpath=/usr/local/mongodb/logs/logs.txt --logappend --nojournal&

   