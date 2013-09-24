
1. 安装依赖包
   yum -y install wget make gcc gcc-c++ g77 perl autoconf automake libxslt libxslt-devel libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel gd2 gd2-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel curl curl-devel openssl openssl-devel glibc glibc-devel 

2. 下载、安装 libmcrypt
   官方下载：ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt

   cd /usr/local/src
   wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz
   tar -xvf libmcrypt-2.5.7.tar.gz
   cd /usr/local/src/libmcrypt-2.5.7
   ./configure
   make
   make install

3. 增加动态文件库路径
if [ ! `grep -l "/lib"    '/etc/ld.so.conf'` ]; then
	echo "/lib" >> /etc/ld.so.conf
fi

if [ ! `grep -l '/usr/lib'    '/etc/ld.so.conf'` ]; then
	echo "/usr/lib" >> /etc/ld.so.conf
fi

if [ -d "/usr/lib64" ] && [ ! `grep -l '/usr/lib64'    '/etc/ld.so.conf'` ]; then
	echo "/usr/lib64" >> /etc/ld.so.conf
fi

if [ ! `grep -l '/usr/local/lib'    '/etc/ld.so.conf'` ]; then
	echo "/usr/local/lib" >> /etc/ld.so.conf
fi

if [ ! `grep -l "/usr/local/mysql/lib"    '/etc/ld.so.conf'` ]; then
	echo "/usr/local/mysql/lib" >> /etc/ld.so.conf
fi

ldconfig

4. 下载、安装 php
   官方下载：http://www.php.net/downloads.php
   说明：安装目录：/usr/local/php 配置文件：/usr/local/php/

   cd /usr/local/src
   wget http://cn2.php.net/distributions/php-5.5.3.tar.gz
   tar -xvf php-5.5.3.tar.gz
   cd /usr/local/src/php-5.5.3
   ./configure \
    --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-mysql=/usr/local/mysql \
    --with-pdo-mysql=/usr/local/mysql \
    --with-mysqli \
    --with-gd \
    --with-openssl \
    --with-jpeg-dir \
    --with-png-dir \
    --with-freetype-dir \
    --with-zlib \
    --with-gettext \
    --with-curl \
    --with-iconv \
    --with-bz2 \
    --with-mcrypt \
    --with-pear \
    --with-xsl \
    --with-libxml-dir=/usr \
    --disable-rpath \
    --enable-opcache \
    --enable-pcntl \
    --enable-mbregex \
    --enable-fpm \
    --enable-exif \
    --enable-calendar \
    --enable-zip \
    --enable-gd-native-ttf \
    --enable-xml \
    --enable-sockets \
    --enable-mbstring=all \
    --enable-bcmath \
    --enable-inline-optimization \
    --enable-ftp ;
   make
   make install

   cp  /usr/local/src/php-5.5.3/php.ini-production  /usr/local/php/etc/php.ini
   cp  /usr/local/php/etc/php-fpm.conf.default  /usr/local/php/etc/php-fpm.conf
   sed -i 's/;pid = run\/php-fpm.pid/pid = run\/php-fpm.pid/g' /usr/local/php/etc/php-fpm.conf
   sed -i 's/;error_log = log\/php-fpm.log/error_log = log\/php-fpm.log/g' /usr/local/php/etc/php-fpm.conf

3. 配置 php.ini 启用 opcache 

cat >> /usr/local/php/etc/php.ini<<EOF
[opcache] 
zend_extension=opcache.so
opcache.memory_consumption=1024 
opcache.optimization_level=1 
opcache.interned_strings_buffer=8 
opcache.max_accelerated_files=4096 
opcache.revalidate_freq=60 
opcache.fast_shutdown=1 
opcache.enable=1 
opcache.enable_cli=1
EOF

验证 opcache 生效情况，请关注 phpinfo() 里 Cache hits 、Cache misses 

4. 管理 php-fpm
   启动：/usr/local/php/sbin/php-fpm
   关闭：kill -INT `cat /usr/local/php/var/run/php-fpm.pid`
   重启：kill -USR2 `cat /usr/local/php/var/run/php-fpm.pid`
   查看进程数：ps aux | grep -c php-fpm


5. 配置nginx支持 php【必须先安装nginx】
   
    cp  /usr/local/nginx/conf/nginx.conf.default  /usr/local/nginx/conf/nginx.conf
    编辑 nginx.conf 去掉 前面 # 
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}
    修改 /scripts$fastcgi_script_name; 为 $document_root$fastcgi_script_name; 
    
    在/usr/local/nginx/html下创建index.php文件，输入如下内容
    <?php echo phpinfo(); ?>

    重启 nginx：/usr/local/nginx/sbin/nginx -s reload
    
    注意临时关闭iptables：service iptables stop 
    打开浏览器访问：http://192.168.56.20/index.php
   