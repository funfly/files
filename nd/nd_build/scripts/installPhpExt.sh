#!/bin/sh

rpm -ivH libmemcached-1.0.4-3.el5.x86_64.rpm libmemcached-devel-1.0.4-3.el5.x86_64.rpm
rpm -ivh libsphinxclient-0.9.9-1.el5.rf.x86_64.rpm libsphinxclient-devel-0.9.9-1.el5.rf.x86_64.rpm

/usr/local/webserver/php/bin/pecl install sphinx
/usr/local/webserver/php/bin/pecl install mongo
/usr/local/webserver/php/bin/pecl install memcache
/usr/local/webserver/php/bin/pecl install memcached
/usr/local/webserver/php/bin/pecl install imagick

gunzip rabbitmq-c-ce1eaceaee94.tar.gz
tar -xf rabbitmq-c-ce1eaceaee94.tar
gunzip rabbitmq-codegen-c7c5876a05bb.tar.gz
tar -xf rabbitmq-codegen-c7c5876a05bb.tar
cp -r rabbitmq-codegen-c7c5876a05bb/ rabbitmq-c-ce1eaceaee94/codegen
cp -r rabbitmq-codegen-c7c5876a05bb/ rabbitmq-c-ce1eaceaee94/librabbitmq/codegen
cd rabbitmq-c-ce1eaceaee94/
autoreconf -i
export ac_abs_confdir=.
./configure
make  # 注意：如果出现编译错误，请运行：rm -rf librabbitmq/codegen 
make install
cd ..

gunzip php-rabbit.r91.tar.gz
tar -xf php-rabbit.r91.tar
cd php-rabbit
/usr/local/webserver/php/bin/phpize
./configure --with-php-config=/usr/local/webserver/php/bin/php-config --with-rabbit
make
make install
cd ..
