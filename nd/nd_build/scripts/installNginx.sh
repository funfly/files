#!/bin/sh

gunzip nginx-1.1.15.tar.gz
tar -xf nginx-1.1.15.tar
cp pcre-8.30.tar.gz nginx-1.1.15/
cp nginx_upload_module-2.2.0.tar.gz nginx-1.1.15/
cd nginx-1.1.15
gunzip pcre-8.30.tar.gz
tar -xf pcre-8.30.tar
gunzip nginx_upload_module-2.2.0.tar.gz
tar -xf nginx_upload_module-2.2.0.tar 
./configure --prefix=/usr/local/webserver/nginx-1.1.15 --with-http_ssl_module --with-pcre=pcre-8.30 --add-module=nginx_upload_module-2.2.0

make
make install
ln -s /usr/local/webserver/nginx-1.1.15 /usr/local/webserver/nginx
mkdir -p /data/saas/logs/nginx/
mv /usr/local/webserver/nginx/logs /data/saas/logs/nginx/
ln -s /data/saas/logs/nginx/logs /usr/local/webserver/nginx/logs
