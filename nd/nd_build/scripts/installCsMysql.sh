#!/bin/sh

gunzip coreseek-3.2.14.tar.gz
gunzip mysql-5.1.38.tar.gz
tar -xf coreseek-3.2.14.tar
tar -xf mysql-5.1.38.tar
cp -r coreseek-3.2.14/csft-3.2.14/mysqlse mysql-5.1.38/storage/sphinx
cd mysql-5.1.38
sh BUILD/autorun.sh
./configure --prefix=/usr/local/webserver/coreseek/mysql-5.1.38 --with-plugins=innobase,myisam,sphinx --with-charset=utf8 --with-extra-charsets=all
make
make install
ln -s /usr/local/webserver/coreseek/mysql-5.1.38 /usr/local/webserver/coreseek/mysql
ln -s /usr/local/webserver/coreseek/mysql/lib/mysql/libmysqlclient.so.16.0.0  /usr/lib/libmysqlclient.so.16
ln -s /usr/local/webserver/coreseek/mysql/lib/mysql/libmysqlclient.so.16.0.0  /usr/local/lib/libmysqlclient.so.16
ln -s /usr/local/webserver/coreseek/mysql/lib/mysql/libmysqlclient.so.16.0.0  /usr/lib64/libmysqlclient.so.16


mkdir -p /data/saas/conf/coreseek/mysql/
mkdir -p /data/saas/data/coreseek/mysql/
mkdir -p /data/saas/logs/coreseek/mysql/binlog/
mkdir -p /data/saas/logs/coreseek/mysql/relaylog/
chown -R mysql:mysql /data/saas/conf/coreseek/mysql/
chown -R mysql:mysql /data/saas/logs/coreseek/mysql/
chown -R mysql:mysql /data/saas/data/coreseek/mysql/

cd /usr/local/webserver/coreseek/mysql
mkdir -p /var/log/mysql var etc
ln -s /data/saas/conf/coreseek/mysql/my.cnf etc/my.cnf 
chown -R mysql:mysql .
bin/mysql_install_db --user=mysql --datadir=/data/saas/data/coreseek/mysql
chmod -R a+x /data/saas/data/coreseek/mysql
chmod -R a+r /data/saas/data/coreseek/mysql

cp share/mysql/mysql.server /etc/init.d/csmysql
chmod +x /etc/init.d/csmysql
chkconfig --add csmysql
service csmysql start
sleep 10

bin/mysqladmin -S /usr/local/webserver/coreseek/mysql/var/mysql.sock -u root password '1abbb33c6f7fe9b3541fc560db3fdf7b'