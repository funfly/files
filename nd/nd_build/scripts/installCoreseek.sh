#!/bin/sh

##��װmmseg
cd coreseek-3.2.14
cd mmseg-3.2.14
./bootstrap    
#warning��Ϣ���Ժ��ԣ������error������
./configure --prefix=/usr/local/webserver/coreseek/mmseg-3.2.14
make
make install
ln -s /usr/local/webserver/coreseek/mmseg-3.2.14 /usr/local/webserver/coreseek/mmseg
ln -s /usr/local/webserver/coreseek/mmseg-3.2.14 /usr/local/webserver/coreseek/mmseg3

cd ..

##��װcoreseek
cd csft-3.2.14
sh buildconf.sh   
#warning��Ϣ���Ժ��ԣ������error������
./configure --prefix=/usr/local/webserver/coreseek/coreseek-3.2.14  --without-unixodbc --with-mmseg --with-mmseg-includes=/usr/local/webserver/coreseek/mmseg/include/mmseg/ --with-mysql --with-mmseg-libs=/usr/local/webserver/coreseek/mmseg/lib/ --with-mysql-includes=/usr/local/webserver/coreseek/mysql/include/mysql --with-mysql-libs=/usr/local/webserver/coreseek/mysql/lib/mysql   
make
make install
ln -s /usr/local/webserver/coreseek/coreseek-3.2.14 /usr/local/webserver/coreseek/coreseek
