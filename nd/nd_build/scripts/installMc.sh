#!/bin/sh

gunzip memcached-1.4.13.tar.gz
tar -xf memcached-1.4.13.tar
cd memcached-1.4.13
./configure --prefix=/usr/local/webserver/memcached-1.4.13
make
make install
ln -s /usr/local/webserver/memcached-1.4.13 /usr/local/webserver/memcached
mkdir /usr/local/webserver/memcached/etc
