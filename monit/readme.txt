

1. 安装依赖包
   yum -y install wget make gcc gcc-c++ pam pam-devel
   
2. 下载、安装 monit
   官方下载：http://mmonit.com/monit/download/
   
   cd /usr/local/src
   wget http://mmonit.com/monit/dist/monit-5.6.tar.gz
   tar -xvf monit-5.6.tar.gz
   cd /usr/local/src/monit-5.6
   ./configure --prefix=/usr/local/monit --without-ssl
   make
   make install
   mkdir -p /usr/local/monit/etc
   cp monitrc /usr/local/monit/etc
   chmod 600 /usr/local/monit/etc/monitrc

3.配置
vi   /usr/local/monit/etc/monitrc

set daemon 30                     #30秒检查一次
set httpd port 2812 and           # monit内置了一个用于查看被监视服务
use address localhost             # 设置只能通过 localhost 访问；建议改成当前服务器IP地址；如：192.168.56.21
allow localhost                   # 允许本地访问
allow 192.168.56.0/255.255.255.0  # 允许该网段的其他机器访问；需要配合设置 use address 192.168.56.21
allow admin:monit                 # 设置使用用户名admin和密码monit

set mailserver smtp.aa.com port 25 USERNAME "aa@aa.com" PASSWORD "123456"  (设置发送邮件的服务器及邮箱)

#制定报警邮件的格式
set mail-format {
    from: aa@aa.com
    subject: $SERVICE $EVENT at $DATE
    message: Monit $ACTION $SERVICE at $DATE on $HOST: $DESCRIPTION.
}

#指定邮件接收者
set alert   bb@aa.com with reminder on 3 cycles 

#监控系统内存、cpu、load、memory、swap使用情况
check system localhost
if loadavg (1min) > 4 then alert
if loadavg (5min) > 2 then alert
if memory usage > 75% then alert
if swap usage > 25% then alert
if cpu usage (user) > 70% then alert
if cpu usage (system) > 30% then alert
if cpu usage (wait) > 20% then alert

#监控磁盘使用情况
check device system with path /
if space usage > 85% for 5 times within 15 cycles then alert
if space usage > 95% then stop
if inode usage > 85% then alert
if inode usage > 95% then stop

#监控apache2
check process apache2 with pidfile /var/run/apache2.pid
start program = "/etc/init.d/apache2 start"
stop  program = "/etc/init.d/apache2 stop"
if 2 restart within 10 cycles then timeout
if cpu usage > 80% for 2 cycles then alert
if failed url http://localhost timeout 120 seconds for 3 cycles then restart #（出现故障则重启服务器）

#监视ssh服务
check process sshd with pidfile /var/run/sshd.pid
start program  "/etc/init.d/sshd start"
stop  program  "/etc/init.d/sshd stop"
if failed host localhost port 22 protocol SSH then restart
if 5 restarts within 5 cycles then timeout

4.管理 monit
启动: /usr/local/monit/bin/monit
关闭: /usr/local/monit/bin/monit quit
重载配置: /usr/local/monit/bin/monit reload

5.查看监控信息
http://localhost:2812

   