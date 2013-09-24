#!/bin/sh

PHP_HOME='/usr/local/webserver/php-5.3.10'
$PHP_HOME/bin/phpize
./configure --with-php-config=$PHP_HOME/php-config
make
make install