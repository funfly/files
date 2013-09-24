1. 安装依赖包
   yum install wget make gcc gcc-c++ g77 perl libdrizzle libdrizzle-devel boost-devel e2fsprogs-devel libevent-devel gperf re2c 

2. 下载、安装 Gearman server and library
   下载地址：https://launchpad.net/gearmand
   
   cd /usr/local/src
   wget https://launchpad.net/gearmand/1.2/1.1.9/+download/gearmand-1.1.9.tar.gz
   tar zxvf gearmand-1.1.9.tar.gz
   cd gearmand-1.1.9/
   ./configure --prefix=/usr/local/gearman
   make
   make install
   
   创建日志目录：
   mkdir /usr/local/gearman/var
   mkdir /usr/local/gearman/var/log

   启动 Gearman
   /usr/local/gearman/sbin/gearmand -d 
   /usr/local/gearman/sbin/gearmand -d -P /usr/local/gearman/var/gearmand.pid
   /usr/local/gearman/sbin/gearmand -d -p 4730 -u root
   
   关闭 Gearman
   /usr/local/gearman/bin/gearadmin --shutdown
   /usr/local/gearman/bin/gearadmin -p 4731 --shutdown
   
3. 下载、安装 Gearman PHP extension
   下载地址：http://pecl.php.net/package/gearman
   
   cd /usr/local/src
   wget http://pecl.php.net/get/gearman-1.1.2.tgz
   tar zxvf gearman-1.1.2.tgz
   cd gearman-1.1.2
   /usr/local/php/bin/phpize
   ./configure --with-php-config=/usr/local/php/bin/php-config --with-gearman=/usr/local/gearman
   make
   make install

　 php.ini文件中增加：
   extension = "gearman.so"

cat >> /usr/local/php/etc/php.ini<<EOF
extension = "gearman.so"
EOF
   
   重启 php-fpm
   kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
   
   查看 phpinfo 是否成功安装 Gearman PHP extension
   http://192.168.56.10/phpinfo.php

4. 测试、体验 Gearman 的同步、异步任务
   a. 将 test 目录上传到 /usr/local/gearman
   b. 启动 worker
      nohup /usr/local/php/bin/php /usr/local/gearman/test/worker.php > /usr/local/gearman/test/worker.log 2>&1 &
   c. 启动 client 
      /usr/local/php/bin/php /usr/local/gearman/test/client.php
   d. 查看日志
      cat /usr/local/gearman/test/worker.log

参考：
    http://blog.s135.com/dips/
    http://www.cppblog.com/guojingjia2006/archive/2013/01/07/197076.html
    http://www.oschina.net/question/234345_42515
    http://www.php.net/manual/zh/book.gearman.php
    