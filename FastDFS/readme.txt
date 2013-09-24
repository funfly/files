1. 安装依赖包
   yum install wget make gcc gcc-c++ g77 perl libevent libevent-devel
   
2. 下载、安装 FastDFS
   下载地址：http://code.google.com/p/fastdfs/downloads/list
   
   cd /usr/local/src
   wget http://fastdfs.googlecode.com/files/FastDFS_v4.06.tar.gz
   tar -xvf FastDFS_v4.06.tar.gz
   cd FastDFS
   ./make.sh
   ./make.sh install
    
   mkdir /home/yuqing
   mkdir /home/yuqing/fastdfs

3. 启动 tracker
   /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf
   
   查看是否启动成功：netstat -an|grep 22122 
   
4. 编辑 
   vi /etc/fdfs/storage.conf
   tracker_server=192.168.xxx.xxx:22122 IP改为 当前服务器的 ip
   
   vi /etc/fdfs/client.conf
   tracker_server=192.168.xxx.xxx:22122 IP改为 当前服务器的 ip

5. 启动 storage
   /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf

6. 测试：
    
    上传文件：/usr/local/bin/fdfs_test /etc/fdfs/storage.conf upload /usr/include/stdlib.h
     
    上传文件：/usr/local/bin/fdfs_upload_file  /etc/fdfs/client.conf /usr/include/stdlib.h
    下载文件：/usr/local/bin/fdfs_download_file /etc/fdfs/client.conf <file_id> [local_filename] 
    删除文件：/usr/local/bin/fdfs_delete_file /etc/fdfs/client.conf <file_id> 
    monitor: /usr/local/bin/fdfs_monitor /etc/fdfs/client.conf 

7.关闭: 

    killall fdfs_trackerd 
    killall fdfs_storaged 
    
    或 
    /usr/local/bin/stop.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf 
    /usr/local/bin/stop.sh /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf 

8.重启: 

    /usr/local/bin/restart.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf 
    /usr/local/bin/restart.sh /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf 

9.编译fastdfs_client.so php扩展模块
   
    cd /usr/local/src/FastDFS/php_client
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config --with-fastdfs_client
    make
    make install
   
   vi /usr/local/php/etc/php.ini
   在末尾增加：
   
[fastdfs_client]
extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20060613/"
extension = fastdfs_client.so
fastdfs_client.base_path = /home/yuqing/fastdfs
fastdfs_client.connect_timeout = 2
fastdfs_client.network_timeout = 60
fastdfs_client.log_level = info
fastdfs_client.log_filename =
fastdfs_client.http.anti_steal_secret_key =
fastdfs_client.tracker_group_count = 1
fastdfs_client.tracker_group0 = /etc/fdfs/client.conf

13.nginx 整合 FastDFS
    将 fastdfs-nginx-module_v1.15.tar.gz 上传到  /usr/local/src
    cd /usr/local/src/
    tar -xvf fastdfs-nginx-module_v1.15.tar.gz
    cd /usr/local/src/lnmp0.8/nginx-1.0.10
    
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6  --add-module=/usr/local/src/fastdfs-nginx-module/src
make && make install

    cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
    
    vi /etc/fdfs/mod_fastdfs.conf
    tracker_server=tracker:22122 改为 tracker_server=192.168.xxx.xxx:22122 IP改为 当前服务器的 ip
    
    vi /usr/local/nginx/conf/nginx.conf
    对应位置增加一下内容：
    
location /M00 {
    alias /home/yuqing/fastdfs/data;
    ngx_fastdfs_module;
}

14.开机自动启动fastdfs
   vi /etc/rc.local
   增加：
/usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf
/usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf

15.测试 fastdfs
   将 fdfs_test.php 上传到 web根目录；重启服务器并访问：http://192.168.xxx.xxx/fdfs_test.php
   

参考：
    http://gary0416.iteye.com/blog/1148790
    http://soartju.iteye.com/blog/803477
    http://soartju.iteye.com/blog/803524
    http://soartju.iteye.com/blog/803548
    http://bbs.chinaunix.net/thread-1920470-1-1.html
    http://code.google.com/p/fastdfs/wiki/Setup
    http://www.nginxs.com/linux/357.html
    http://duchengjiu.iteye.com/blog/1748295