#!/bin/sh

unzip eaccelerator-0.9.6.1.zip
cd eaccelerator-0.9.6.1
/usr/local/webserver/php/bin/phpize
./configure --enable-eaccelerator=shared --with-eaccelerator-info --with-php-config=/usr/local/webserver/php/bin/php-config
make
make install

mkdir /var/tmp/eaccelerator

