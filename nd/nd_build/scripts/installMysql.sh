#!/bin/sh

# ±àÒëºÍ°²×°
gunzip mysql-5.5.22.tar.gz
tar -xf mysql-5.5.22.tar
cd mysql-5.5.22
export MYSQL_HOME=/usr/local/webserver/mysql-5.5.22
sh BUILD/autorun.sh
./configure --prefix=${MYSQL_HOME} --with-plugins=innobase,myisam --with-charset=utf8 --with-extra-charsets=all
make
make install
groupadd mysql
useradd -g mysql mysql
chown -R mysql:mysql ${MYSQL_HOME}
ln -s ${MYSQL_HOME} /usr/local/webserver/mysql
chown mysql:mysql /usr/local/webserver/mysql
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql
mkdir -p /data/saas/conf/mysql/
export PATH=${MYSQL_HOME}/bin:${PATH}

mkdir -p /data/saas/data/mysql/3306
mkdir -p /data/saas/data/mysql/3307
mkdir -p /data/saas/data/mysql/3308
mkdir -p /data/saas/data/mysql/3309
mkdir -p /data/saas/data/mysql/3312
chmod -R a+x /data/saas/data/mysql 
chmod -R a+r /data/saas/data/mysql

mkdir -p /data/saas/logs/mysql/3306/binlog
mkdir -p /data/saas/logs/mysql/3307/binlog
mkdir -p /data/saas/logs/mysql/3308/binlog
mkdir -p /data/saas/logs/mysql/3309/binlog
mkdir -p /data/saas/logs/mysql/3312/binlog

mkdir -p /data/saas/logs/mysql/3306/relaylog
mkdir -p /data/saas/logs/mysql/3307/relaylog
mkdir -p /data/saas/logs/mysql/3308/relaylog
mkdir -p /data/saas/logs/mysql/3309/relaylog
mkdir -p /data/saas/logs/mysql/3312/relaylog

chown -R mysql:mysql /data/saas/data/mysql
chown -R mysql:mysql /data/saas/logs/mysql
chown -R mysql:mysql /data/saas/conf/mysql

chmod +x /data/saas/conf/mysql/mysqld_safe_with_conf.sh
chmod +x /data/saas/conf/mysql/mysqld_multi_with_conf.sh

cd ${MYSQL_HOME}
scripts/mysql_install_db --defaults-file=/data/saas/conf/mysql/my.cnf --user=mysql --datadir=/data/saas/data/mysql/3306 
scripts/mysql_install_db --defaults-file=/data/saas/conf/mysql/my.cnf --user=mysql --datadir=/data/saas/data/mysql/3307
scripts/mysql_install_db --defaults-file=/data/saas/conf/mysql/my.cnf --user=mysql --datadir=/data/saas/data/mysql/3308
scripts/mysql_install_db --defaults-file=/data/saas/conf/mysql/my.cnf --user=mysql --datadir=/data/saas/data/mysql/3309
scripts/mysql_install_db --defaults-file=/data/saas/conf/mysql/my.cnf --user=mysql --datadir=/data/saas/data/mysql/3312

chmod +x /etc/init.d/mysql
chkconfig --add mysql
service mysql start

sleep 10

bin/mysqladmin -S /usr/local/webserver/mysql/3306/mysql.sock -u root password '1abbb33c6f7fe9b3541fc560db3fdf7b'
bin/mysqladmin -S /usr/local/webserver/mysql/3307/mysql.sock -u root password ¡®1abbb33c6f7fe9b3541fc560db3fdf7b¡¯
bin/mysqladmin -S /usr/local/webserver/mysql/3308/mysql.sock -u root password '1abbb33c6f7fe9b3541fc560db3fdf7b'
bin/mysqladmin -S /usr/local/webserver/mysql/3309/mysql.sock -u root password '1abbb33c6f7fe9b3541fc560db3fdf7b'
bin/mysqladmin -S /usr/local/webserver/mysql/3312/mysql.sock -u root password '1abbb33c6f7fe9b3541fc560db3fdf7b'




