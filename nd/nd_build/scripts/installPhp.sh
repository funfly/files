#!/bin/sh

yum -y install gmp gmp-devel
yum -y install libxml2 libxml2-devel
yum -y install curl curl-devel
yum -y install libpng libpng-devel
yum -y install libjpeg libjpeg-devel
yum -y install libXpm libXpm-devel
yum -y install libmcrypt libmcrypt-devel
yum -y install freetype freetype-devel
yum -y install libxslt libxslt-devel
yum -y install openssl openssl-devel
yum -y install ImageMagick ImageMagick-devel
yum -y install cyrus-sasl cyrus-sasl-devel

gunzip php-5.3.10.tar.gz
tar -xf php-5.3.10.tar
cd php-5.3.10
./configure --prefix=/usr/local/webserver/php-5.3.10 --with-config-file-path=/usr/local/webserver/php-5.3.10/etc --enable-fpm --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-iconv --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir --with-curl --with-curlwrappers --with-mcrypt --with-gd --with-openssl --with-mhash --with-xmlrpc --with-pear --enable-fpm --with-gmp  --enable-exif --enable-safe-mode --enable-static --enable-calendar --enable-mbstring --enable-xml --enable-sockets --enable-zip --enable-soap --enable-gd-native-ttf --enable-inline-optimization --enable-ftp --enable-zend-multibyte --enable-zip --enable-gd-native-ttf --with-xsl --with-xpm-dir=/usr
make # 注：如果碰到关于iconv的错误，请运行 make ZEND_EXTRA_LIBS='-liconv'
make install

ln -s /usr/local/webserver/php-5.3.10 /usr/local/webserver/php
ln -s /usr/local/webserver/php-5.3.10/bin/php /usr/local/bin/php
cp /usr/local/webserver/php/etc/php-fpm.conf.default /usr/local/webserver/php/etc/php-fpm.conf

mkdir -p /data/saas/logs/php/
mv /usr/local/webserver/php/var/log /data/saas/logs/php/
ln -s /data/saas/logs/php/log /usr/local/webserver/php/var/log
chown nobody:nobody /tmp/

