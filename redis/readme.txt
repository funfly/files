
1. 安装依赖包
   yum -y install gcc wget make tcl
   
2. 下载、解压、安装 redis    【下载地址：http://redis.io/download】
   cd /usr/local/src
   wget http://download.redis.io/releases/redis-2.6.16.tar.gz
   tar -xvf redis-2.6.16.tar.gz
   mv redis-2.6.16 /usr/local/redis 
   cd /usr/local/redis 
   make
   make install

3. 创建数据目录，并配置redis
   mkdir /home/redis
   将 conf-10/redis.conf 上传到：/usr/local/redis/
   
4. 启动redis
   vi /usr/local/redis/redis.conf
   修改：daemaon no 为daemaon yes
   
   /usr/local/redis/src/redis-server /usr/local/redis/redis.conf
   /usr/local/redis/src/redis-server /usr/local/redis/redis.conf --slaveof 192.168.56.10 6379
   验证运行状态：netstat -ntl 或者 ps -aux|grep redis
   
5. 其他操作：

   #测试是否已启动
   /usr/local/redis/src/redis-cli ping
   /usr/local/redis/src/redis-cli -h 192.168.56.10 ping #绑定特定IP，请使用该命令
   #性能测试
   /usr/local/redis/src/redis-benchmark
   #关闭服务
   /usr/local/redis/src/redis-cli shutdown                          #关闭所有
   /usr/local/redis/src/redis-cli -h 192.168.56.10 shutdown         #关闭所有 绑定特定IP，请使用该命令
   /usr/local/redis/src/redis-cli -p 6397 shutdown                  #关闭6397端口的redis
  
   #强制刷新数据到磁盘【Redis默认是异步写入磁盘的】
    /usr/local/redis/src/redis-cli -p6379 save

6. 测试redis
   /usr/local/redis/src/redis-cli -h 192.168.56.10 set test 'hi...'
   /usr/local/redis/src/redis-cli -h 192.168.56.10 get test

7. 安装php redis扩展

    wget https://github.com/nicolasff/phpredis/zipball/master -O php-redis.zip
    unzip php-redis.zip
    cd nicolasff-phpredis-504724b/
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install

   修改php.ini
   vi /usr/local/php/etc/php.ini
   加入：
   extension=redis.so
   
   重启 php-fpm
   /usr/local/php/sbin/php-fpm restart
   
   查看 phpinfo 验证 redis 扩展是否安装成功
   http://192.168.56.12/phpinfo.php
   
8. 配置 redis 主从
   将 conf-10/redis.conf 上传到 192.168.56.10 服务器的 /usr/local/redis/ 目录，并启动 reids 【master】
   将 conf-11/redis.conf 上传到 192.168.56.11 服务器的 /usr/local/redis/ 目录，并启动 reids 【slave】
   查看各自服务器的日志：
   tail -f /var/log/redis.log
   
9. redis 高可用性 故障转移方案请看目录：redis-ha   

参考：
   http://www.nginx.cn/tag/redis
   http://www.springload.cn/springload/detail/471
   http://blog.haohtml.com/archives/10385
   http://www.cnblogs.com/weafer/archive/2011/09/21/2184059.html
   

   

