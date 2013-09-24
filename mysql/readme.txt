
1. 安装依赖包
   yum -y install wget make cmake gcc gcc-c++ g77 perl autoconf automake libaio libaio-devel bison ncurses-devel 
   #zlib* fiex* libxml* libmcrypt* libtool-ltdl-devel*

2. 下载、安装 mysql 【编译安装】
   官方下载：http://dev.mysql.com/downloads/mysql/
   说明：选择 Source code 下载 Generic Linux (Architecture Independent), Compressed TAR Archive 版本；
         mysql 安装目录：/usr/local/mysql 数据目录：/usr/local/mysql/data  配置文件目录：/usr/local/mysql/my.cnf

   cd /usr/local/src
   wget http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz
   tar -xvf mysql-5.6.13.tar.gz
   cd /usr/local/src/mysql-5.6.13
   make clean
   rm -f CMakeCache.txt
   cmake \
   -DENABLE_DOWNLOADS=1 \
   -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
   -DMYSQL_DATADIR=/usr/local/mysql/data \
   -DSYSCONFDIR=/usr/local/mysql \
   -DWITH_MYISAM_STORAGE_ENGINE=1 \
   -DWITH_INNOBASE_STORAGE_ENGINE=1 \
   -DWITH_MEMORY_STORAGE_ENGINE=1 \
   -DMYSQL_UNIX_ADDR=/tmp/mysqld3306.sock \
   -DMYSQL_TCP_PORT=3306 \
   -DENABLED_LOCAL_INFILE=1 \
   -DWITH_PARTITION_STORAGE_ENGINE=1 \
   -DEXTRA_CHARSETS=all \
   -DDEFAULT_CHARSET=utf8 \
   -DDEFAULT_COLLATION=utf8_general_ci;
   make
   make install
   
   提示：如果出现 Googlemock was not found
         请执行以下代码，然后 cd /usr/local/src/mysql-5.6.13; make clean;rm -f CMakeCache.txt; 再重新 cmake 一遍就可以了；
   cd /usr/local/src/mysql-5.6.13/source_downloads
   unzip gmock-1.6.0.zip
   cd gmock-1.6.0
   ./configure
   make

3. 下载、安装 mysql 【普通安装】（编译安装或普通安装2选1）
   官方下载：http://dev.mysql.com/downloads/mysql/
   说明：选择 Linux - Generic 下载 Linux - Generic (glibc 2.5) (x86, 32-bit), Compressed TAR Archive 版本；
         mysql 安装目录：/usr/local/mysql 数据目录：/usr/local/mysql/data  配置文件目录：/usr/local/mysql/my.cnf

   cd /usr/local/src
   wget http://cdn.mysql.com/Downloads/MySQL-5.6/mysql-5.6.13-linux-glibc2.5-i686.tar.gz
   tar -xvf mysql-5.6.13-linux-glibc2.5-i686.tar.gz
   mv mysql-5.6.13-linux-glibc2.5-i686 mysql /uer/local/mysql

4. 初始化 mysql
   groupadd mysql
   useradd mysql -g mysql -M -s /sbin/nologin
   chown -R mysql.mysql /usr/local/mysql
   cd /usr/local/mysql/scripts
   ./mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
   
5. 将 MySQL 加入系统服务
   cd /usr/local/mysql/support-files
   cp mysql.server /etc/init.d/mysqld
   chmod 755 /etc/init.d/mysqld
   service mysqld start

6. 将 MySQL 设置为开机启动
   chkconfig --add mysqld
   chkconfig mysqld on

7. 管理 mysql
   启动：/etc/rc.d/init.d/mysqld start     或 service mysqld start
   重启：/etc/rc.d/init.d/mysqld restart   或 service mysqld restart
   停止：/etc/rc.d/init.d/mysqld stop      或 service mysqld stop

8. 设置 mysql 账户密码

/etc/rc.d/init.d/mysqld start
/usr/local/mysql/bin/mysqladmin -u root password 123456
cat > /tmp/init_mysql_privileges.sql<<EOF
grant all privileges on *.* to root@'%' identified by '123456';
use mysql;
update user set password=password('123456') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and password='';
flush privileges;
EOF
/usr/local/mysql/bin/mysql -u root -p123456 < /tmp/init_mysql_privileges.sql
rm -f /tmp/init_mysql_privileges.sql

7. 进入并测试 mysql
  /usr/local/mysql/bin/mysql -u root -p123456


===========================================================
cmake 选项：

cmake \
-DENABLE_DOWNLOADS=1                        #允许下载相关模块
-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \   #安装路径
-DMYSQL_DATADIR=/usr/local/mysql/data \     #数据文件存放位置
-DSYSCONFDIR=/usr/local/mysql \             #my.cnf路径
-DWITH_MYISAM_STORAGE_ENGINE=1 \            #支持MyIASM引擎
-DWITH_INNOBASE_STORAGE_ENGINE=1 \          #支持InnoDB引擎
-DWITH_MEMORY_STORAGE_ENGINE=1 \            #支持Memory引擎
-DWITH_READLINE=1 \                         #快捷键功能(我没用过)
-DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \        #连接数据库socket路径
-DMYSQL_TCP_PORT=3306 \                     #端口
-DENABLED_LOCAL_INFILE=1 \                  #允许从本地导入数据
-DWITH_PARTITION_STORAGE_ENGINE=1 \         #安装支持数据库分区
-DEXTRA_CHARSETS=all \                      #安装所有的字符集
-DDEFAULT_CHARSET=utf8 \                    #默认字符
-DDEFAULT_COLLATION=utf8_general_ci \