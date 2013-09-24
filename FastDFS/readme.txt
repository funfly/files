1. ��װ������
   yum install wget make gcc gcc-c++ g77 perl libevent libevent-devel
   
2. ���ء���װ FastDFS
   ���ص�ַ��http://code.google.com/p/fastdfs/downloads/list
   
   cd /usr/local/src
   wget http://fastdfs.googlecode.com/files/FastDFS_v4.06.tar.gz
   tar -xvf FastDFS_v4.06.tar.gz
   cd FastDFS
   ./make.sh
   ./make.sh install
    
   mkdir /home/yuqing
   mkdir /home/yuqing/fastdfs

3. ���� tracker
   /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf
   
   �鿴�Ƿ������ɹ���netstat -an|grep 22122 
   
4. �༭ 
   vi /etc/fdfs/storage.conf
   tracker_server=192.168.xxx.xxx:22122 IP��Ϊ ��ǰ�������� ip
   
   vi /etc/fdfs/client.conf
   tracker_server=192.168.xxx.xxx:22122 IP��Ϊ ��ǰ�������� ip

5. ���� storage
   /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf

6. ���ԣ�
    
    �ϴ��ļ���/usr/local/bin/fdfs_test /etc/fdfs/storage.conf upload /usr/include/stdlib.h
     
    �ϴ��ļ���/usr/local/bin/fdfs_upload_file  /etc/fdfs/client.conf /usr/include/stdlib.h
    �����ļ���/usr/local/bin/fdfs_download_file /etc/fdfs/client.conf <file_id> [local_filename] 
    ɾ���ļ���/usr/local/bin/fdfs_delete_file /etc/fdfs/client.conf <file_id> 
    monitor: /usr/local/bin/fdfs_monitor /etc/fdfs/client.conf 

7.�ر�: 

    killall fdfs_trackerd 
    killall fdfs_storaged 
    
    �� 
    /usr/local/bin/stop.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf 
    /usr/local/bin/stop.sh /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf 

8.����: 

    /usr/local/bin/restart.sh /usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf 
    /usr/local/bin/restart.sh /usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf 

9.����fastdfs_client.so php��չģ��
   
    cd /usr/local/src/FastDFS/php_client
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config --with-fastdfs_client
    make
    make install
   
   vi /usr/local/php/etc/php.ini
   ��ĩβ���ӣ�
   
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

13.nginx ���� FastDFS
    �� fastdfs-nginx-module_v1.15.tar.gz �ϴ���  /usr/local/src
    cd /usr/local/src/
    tar -xvf fastdfs-nginx-module_v1.15.tar.gz
    cd /usr/local/src/lnmp0.8/nginx-1.0.10
    
./configure --user=www --group=www --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6  --add-module=/usr/local/src/fastdfs-nginx-module/src
make && make install

    cp /usr/local/src/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/
    
    vi /etc/fdfs/mod_fastdfs.conf
    tracker_server=tracker:22122 ��Ϊ tracker_server=192.168.xxx.xxx:22122 IP��Ϊ ��ǰ�������� ip
    
    vi /usr/local/nginx/conf/nginx.conf
    ��Ӧλ������һ�����ݣ�
    
location /M00 {
    alias /home/yuqing/fastdfs/data;
    ngx_fastdfs_module;
}

14.�����Զ�����fastdfs
   vi /etc/rc.local
   ���ӣ�
/usr/local/bin/fdfs_trackerd /etc/fdfs/tracker.conf
/usr/local/bin/fdfs_storaged /etc/fdfs/storage.conf

15.���� fastdfs
   �� fdfs_test.php �ϴ��� web��Ŀ¼�����������������ʣ�http://192.168.xxx.xxx/fdfs_test.php
   

�ο���
    http://gary0416.iteye.com/blog/1148790
    http://soartju.iteye.com/blog/803477
    http://soartju.iteye.com/blog/803524
    http://soartju.iteye.com/blog/803548
    http://bbs.chinaunix.net/thread-1920470-1-1.html
    http://code.google.com/p/fastdfs/wiki/Setup
    http://www.nginxs.com/linux/357.html
    http://duchengjiu.iteye.com/blog/1748295