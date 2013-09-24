#!/bin/sh

##安装mmseg
cd coreseek-3.2.14
cd mmseg-3.2.14
./bootstrap    
#warning信息可以忽略，如果有error则需解决
./configure --prefix=/usr/local/webserver/coreseek/mmseg-3.2.14
make
make install
ln -s /usr/local/webserver/coreseek/mmseg-3.2.14 /usr/local/webserver/coreseek/mmseg
ln -s /usr/local/webserver/coreseek/mmseg-3.2.14 /usr/local/webserver/coreseek/mmseg3

cd ..

##安装coreseek
cd csft-3.2.14
sh buildconf.sh   
#warning信息可以忽略，如果有error则需解决
./configure --prefix=/usr/local/webserver/coreseek/coreseek-3.2.14  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/webserver/coreseek/mmseg/include/mmseg/ --with-mysql --with-mmseg-libs=/usr/local/webserver/coreseek/mmseg/lib/ --with-mysql-includes=/usr/local/webserver/coreseek/mysql/include/mysql --with-mysql-libs=/usr/local/webserver/coreseek/mysql/lib/mysql   
make
make install
ln -s /usr/local/webserver/coreseek/coreseek-3.2.14 /usr/local/webserver/coreseek/coreseek
