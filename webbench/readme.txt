安装：

将 webbench-1.5.tar.gz 拷贝到 /usr/local/src
cd /usr/local/src
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make && make install

使用：

webbench -c 1000 -t 60 http://www.qonou.com/test.html    参数说明：-c表示并发数，-t表示时间(秒)

webbench -c 1000 -t 60 http://www.qonou.com/index.php?do=apiTongji_test

测试结果示例：

Webbench - Simple Web Benchmark 1.5
Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.

Benchmarking: GET http://127.0.0.1/test.jpg
500 clients, running 30 sec.

Speed=3230 pages/min, 11614212 bytes/sec.
Requests: 1615 susceed, 0 failed.


============================================
yum install ctags

mkdir -m 644 -p /usr/local/man/man1
cd /usr/local/src
wget http://blog.s135.com/soft/linux/webbench/webbench-1.5.tar.gz
tar zxvf webbench-1.5.tar.gz
cd webbench-1.5
make 
make install
echo "192.168.1.86 www.qonou.com" >> /etc/hosts

参考：http://www.centos.bz/2011/10/linux-webbench/




1. 安装依赖包
   yum -y install wget make gcc gcc-c++ ctags

2. 下载、安装 webbench
   官方下载：http://www.nodejs.org/download/

   cd /usr/local/src
   tar -xvf webbench-1.5.tar.gz
   cd webbench-1.5
   make && make install

3. 使用：

webbench -c 1000 -t 60 http://www.test.com/test.html    参数说明：-c表示并发数，-t表示时间(秒)
webbench -c 1000 -t 60 http://www.test.com/index.php?do=xxx

测试结果示例：

Webbench - Simple Web Benchmark 1.5
Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.

Benchmarking: GET http://127.0.0.1/test.jpg
500 clients, running 30 sec.

Speed=3230 pages/min, 11614212 bytes/sec.
Requests: 1615 susceed, 0 failed.

