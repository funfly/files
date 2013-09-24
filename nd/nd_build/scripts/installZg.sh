#!/bin/sh

gunzip ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz
tar -xf ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar
cp ZendGuardLoader-php-5.3-linux-glibc23-x86_64/php-5.3.x/ZendGuardLoader.so /usr/local/webserver/php/lib/php/
