

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

3. 安装 php mongodb扩展
   wget http://pecl.php.net/get/mongo-1.2.0.tgz
   tar xvf mongo-1.2.0.tgz
   cd mongo-1.2.0
   /usr/local/php/bin/phpize
   ./configure --with-php-config=/usr/local/php/bin/php-config
   make && make install
   
   修改php.ini
   vi /usr/local/php/etc/php.ini
   加入：
   extension=mongo.so
   
   重启 php-fpm
   /usr/local/php/sbin/php-fpm restart
   
   查看 phpinfo 验证 redis 扩展是否安装成功
   http://192.168.56.12/phpinfo.php