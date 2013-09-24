
1. 安装依赖包
   yum -y install gcc popt-devel openssl-devel wget make

2. 下载、解压、安装 【官方下载地址：http://www.keepalived.org/download.html】
   cd /usr/local/src
   wget http://www.keepalived.org/software/keepalived-1.2.7.tar.gz
   tar -xvf keepalived-1.2.7.tar.gz
   cd /usr/local/src/keepalived-1.2.7
   ./configure --prefix=/usr/local/keepalived
   make
   make install
   cp /usr/local/keepalived/sbin/keepalived /usr/sbin/
   cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
   cp /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/


3. 配置 keepalived（默认情况下keepalived启动时会去/etc/keepalived目录下找配置文件）
   mkdir /etc/keepalived
   将 conf-10/keepalived.conf 上传到IP为：192.168.56.10 的  /etc/keepalived
   将 conf-11/keepalived.conf 上传到IP为：192.168.56.11 的  /etc/keepalived
   
4. 启动 keepalived
   /usr/local/keepalived/sbin/keepalived -D
   ps -aux | grep keepalived

5. 验证 keepalived 的虚拟IP
   用其他服务器ping VIP；可以ping通虚拟ip
   ping 192.168.56.100

6. 测试 keepalived 的健康检查程序是否能触发相关脚本；VIP是否自动切换
   mkdir /home/tool
   上传 pkill_keepalived.sh 到 /home/tool
   chmod +x /home/tool/pkill_keepalived.sh
   
   实现步骤：
       1. 服务器1 : 192.168.56.10  VIP:192.168.56.100   【暂时关闭iptables】
       2. 服务器2 : 192.168.56.11  VIP:192.168.56.100   【暂时关闭iptables】
       3. 服务器3 : 192.168.56.12  VIP:192.168.56.100   【暂时关闭iptables】
       4. 启动散个服务器的nginx，并访问：
          http://192.168.56.10/index.php 该服务器当前网页内容：10...
          http://192.168.56.11/index.php 该服务器当前网页内容：11...
          http://192.168.56.12/index.php 该服务器当前网页内容：12...
       5. 依次启动三个服务器的keepalived：/usr/local/keepalived/sbin/keepalived -D
       6. 分别查看三个服务器的日志：tail -f /var/log/messages
       7. 通过虚拟IP，访问网页：http://192.168.56.100/index.php 当前内容应该是：10...
       8. 停止 192.168.56.10 上的 nginx 服务，并观察三个服务器的日志，如：/etc/init.d/mysqld stop 此时，VIP指向192.168.56.11服务器
       9. 再次通过虚拟IP，访问网页：http://192.168.56.100/index.php 当前内容应该是：11...
       10.可以继续停止 192.168.56.11 上的 nginx 服务；让VIP指向192.168.56.12服务器；访问 http://192.168.56.100/index.php 内容应该是：12...
       
7. 关闭 keepalived
   pkill keepalived

8. 查看日志
   tail -f /var/log/messages

参考：
   http://kb.cnblogs.com/page/83944/
   