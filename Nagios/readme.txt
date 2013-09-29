

1. 安装依赖包
    yum -y install wget make gcc gcc-c++ perl perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker unzip gd gd-devel gd2 gd2-devel openssl openssl-devel glibc glibc-devel 

2. 下载、安装FCGI模块
    
    cd /usr/local/src
    wget http://search.cpan.org/CPAN/authors/id/F/FL/FLORA/FCGI-0.73.tar.gz
    tar xvzf FCGI-0.73.tar.gz
    cd FCGI-0.73
    perl Makefile.PL
    make
    make install
    
3. 下载、安装FCGI-ProcManager模块

    cd /usr/local/src
    wget http://search.cpan.org/CPAN/authors/id/G/GB/GBJK/FCGI-ProcManager-0.19.tar.gz
    tar xvzf FCGI-ProcManager-0.19.tar.gz
    cd FCGI-ProcManager-0.19
    perl Makefile.PL
    make
    make install
    
4. 下载、安装IO和IO::ALL模块

    cd /usr/local/src
    wget http://search.cpan.org/CPAN/authors/id/G/GB/GBARR/IO-1.25.tar.gz
    tar zxvf IO-1.25.tar.gz
    cd IO-1.25
    perl Makefile.PL
    make
    make install

    cd /usr/local/src
    wget http://search.cpan.org/CPAN/authors/id/I/IN/INGY/IO-All-0.41.tar.gz
    tar zxvf IO-All-0.41.tar.gz
    cd IO-All-0.41
    perl Makefile.PL
    make
    make install

5. 下载Perl脚本
    这个脚本的目的就是产生一个PERL的FastCGI接口，让Nginx可以以CGI方式处理Perl，把这个脚本放在Nginx安装目录并修改脚本权限

    cd /usr/local/src
    wget http://www.mike.org.cn/wp-content/uploads/2011/07/perl-fcgi.zip
    unzip perl-fcgi.zip
    cp perl-fcgi.pl /usr/local/nginx/
    chmod 755 /usr/local/nginx/perl-fcgi.pl

6. 建立一个CGI启动/停止脚本
    这个SHELL脚本只是为了方便管理上面的Perl脚本。脚本中的www为nginx的运行用户，请据自己的实际情况调整。
    注意事项：不能用root用户执行(会提示). 要用与Nginx相同身份的用户执行。否则可能会在Nginx Log中提示 Permision Denied。

    vi /usr/local/nginx/start_perl_cgi.sh

#!/bin/bash
#set -x
dir=/usr/local/nginx/

stop ()
{
#pkill  -f  $dir/perl-fcgi.pl
kill $(cat $dir/logs/perl-fcgi.pid)
rm $dir/logs/perl-fcgi.pid 2>/dev/null
rm $dir/logs/perl-fcgi.sock 2>/dev/null
echo "stop perl-fcgi done"
}

start ()
{
rm $dir/now_start_perl_fcgi.sh 2>/dev/null

chown www.www $dir/logs
echo "$dir/perl-fcgi.pl -l $dir/logs/perl-fcgi.log -pid $dir/logs/perl-fcgi.pid -S $dir/logs/perl-fcgi.sock" >>$dir/now_start_perl_fcgi.sh

chown www.www $dir/now_start_perl_fcgi.sh
chmod u+x $dir/now_start_perl_fcgi.sh

sudo -u www $dir/now_start_perl_fcgi.sh
echo "start perl-fcgi done"
}

case $1 in
stop)
stop
;;
start)
start
;;
restart)
stop
start
;;
esac

    修改SHELL脚本权限
    chmod 755 /usr/local/nginx/start_perl_cgi.sh

    启动脚本
    /usr/local/nginx/start_perl_cgi.sh start
    正常情况下在/usr/local/nginx/logs下生成perl-fcgi.sock这个文件,如果没有生成,请检查下上面的步聚。

7. 下载 安装Nagios

    cd /usr/local/src
    wget http://prdownloads.sourceforge.net/sourceforge/nagios/nagios-3.2.3.tar.gz
    wget http://prdownloads.sourceforge.net/sourceforge/nagiosplug/nagios-plugins-1.4.15.tar.gz
    wget http://prdownloads.sourceforge.net/sourceforge/nagios/nrpe-2.12.tar.gz

    /usr/sbin/useradd -m -s /sbin/nologin nagios
    groupadd nagcmd
    usermod -a -G nagcmd nagios
    usermod -a -G nagcmd www
    
    cd /usr/local/src
    tar zxvf nagios-3.2.3.tar.gz
    cd nagios-3.2.3
    ./configure --with-command-group=nagcmd
    make
    make all
    make install
    make install-init
    make install-config
    make install-commandmode
    
    注：
    make install 用于安装主要的程序、CGI及HTML文件
    make install-init 用于生成init启动脚本
    make install-config 用于安装示例配置文件
    make install-commandmode 用于设置相应的目录权限
    make install-webconf 用于安装Apache配置文件 #这里是在Nginx下运行Nagios,这一步就不用做了

    正确安装后目录：
    ls /usr/local/nagios
    /usr/local/nagios/bin           #Nagios执行程序所在目录，其中的nagios文件即为主程序。
    /usr/local/nagios/etc           #Nagios配置文件位置
    /usr/local/nagios/sbin          #Nagios cgi文件所在目录，也就是执行外部命令所需文件所在的目录
    /usr/local/nagios/Share         #Nagios网页文件所在的目录
    /usr/local/nagios/var           #Nagios日志文件、spid 等文件所在的目录
    /usr/local/nagios/var/archives  #日志归档目录
    /usr/local/nagios/var/rw        #用来存放外部命令文件

8. 配置Nagios Web界面登陆帐号及密码
    htpasswd -c /usr/local/nagios/etc/nagiospasswd funfly
    如果你没有htpasswd(这个工具由Apache安装包所提供),可在线生成需要加密数据。
    a) 访问http://www.4webhelp.net/us/password.php生成需要加密数据
    b) 创建加密验证文件
        vi /usr/local/nagios/etc/nagiospasswd

        加入生成的加密数据，冒号前是用户名，后面是加密后的密码，密码是123456

        funfly:40OUnF.ApI/GY

    修改Nagios配置文件，给新增的用户增加访问权限

    vi /usr/local/nagios/etc/cgi.cfg

#以下几项中分别加入新增的用户，多用户用逗号分隔。
authorized_for_system_information=nagiosadmin,funfly
authorized_for_configuration_information=nagiosadmin,funfly
authorized_for_system_commands=nagiosadmin,funfly
authorized_for_all_services=nagiosadmin,funfly
authorized_for_all_hosts=nagiosadmin,funfly
authorized_for_all_service_commands=nagiosadmin,funfly
authorized_for_all_host_commands=nagiosadmin,funfly

9. 修改NGINX配置，以支持WEB方式访问Nagios

方法一：以http://ip方式访问

NGINX配置片断如下

server
{
    listen       80;
    server_name  192.168.56.10;
    index index.html index.htm index.php;
    root  /usr/local/nagios/share;
    auth_basic "Nagios Access";
    auth_basic_user_file /usr/local/nagios/etc/nagiospasswd;
    location ~ .*\.(php|php5)?$
    {
        #fastcgi_pass  unix:/tmp/php-cgi.sock;
        fastcgi_pass  127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name; 
        include fastcgi_params;
    }
    
    location ~ .*\.(cgi|pl)?$
    {
        gzip off;
        root   /usr/local/nagios/sbin;
        rewrite ^/nagios/cgi-bin/(.*)\.cgi /$1.cgi break;
        fastcgi_pass  unix:/usr/local/nginx/logs/perl-fcgi.sock;
        fastcgi_param SCRIPT_FILENAME /usr/local/nagios/sbin$fastcgi_script_name;
        fastcgi_index index.cgi;
        fastcgi_read_timeout   60;
        fastcgi_param  REMOTE_USER        $remote_user;
        include fastcgi_params;
        auth_basic "Nagios Access";
        auth_basic_user_file /usr/local/nagios/etc/nagiospasswd;
    }
    
    location /nagios
    {
        alias /usr/local/nagios/share;
        auth_basic "Nagios Access";
        auth_basic_user_file /usr/local/nagios/etc/nagiospasswd;
    }

}

方法二：以http://ip/nagios方式访问

在WEB主目录下创建一个软链

ln -s  /usr/local/nagios/share/  /data0/htdocs/www/nagios

server
{
    listen       80;
    server_name  192.168.56.10;
    index index.html index.htm index.php;
    root  /data0/htdocs/www;
    auth_basic "Nagios Access";
    auth_basic_user_file /usr/local/nagios/etc/nagiospasswd;
    location ~ .*\.(php|php5)?$
    {
        #fastcgi_pass  unix:/tmp/php-cgi.sock;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name; 
        include        fastcgi_params;
    }
    
    location ~ .*\.(cgi|pl)?$
    {
        gzip off;
        root   /usr/local/nagios/sbin;
        rewrite ^/nagios/cgi-bin/(.*)\.cgi /$1.cgi break;
        fastcgi_pass  unix:/usr/local/nginx/logs/perl-fcgi.sock;
        fastcgi_param SCRIPT_FILENAME /usr/local/nagios/sbin$fastcgi_script_name;
        fastcgi_index index.cgi;
        fastcgi_read_timeout   60;
        fastcgi_param  REMOTE_USER        $remote_user;
        include fastcgi_params;
        auth_basic "Nagios Access";
        auth_basic_user_file /usr/local/nagios/etc/nagiospasswd;
    }

}

注：如果你的fastcgi的配置文件中没有配置REMOTE_USER参数，一定要在nginx.conf中加上下面这个fastcgi的参数定义。
fastcgi_param  REMOTE_USER        $remote_user;

如果没有这个fastcgi的参数定义，Nagios就不能正确验证你的登陆信息。网上大多数文章解决Nginx下Nagios登陆验证失败的方法都是在Nagios的cgi.cfg配置文件(nagios/etc/cgi.cfg)中关掉验证(use_authentication=0)或设置一个缺省的登陆用户(default_user_name=test)，这两种方法都是不安全的。

10.编译并安装Nagios插件
    由于Nagios主程序只是提供一个运行框架，其具体监控是靠运行在其下的插件完成的，所以Nagios插件是必须安装的。

    cd /usr/local/src
    tar zxvf nagios-plugins-1.4.15.tar.gz
    cd nagios-plugins-1.4.15
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios
    make
    make install

    验证Nagios插件是否正确安装
    ls /usr/local/nagios/libexec
    显示安装的插件文件,即所有的插件都安装在libexec这个目录下。

11.启动服务
    启动前先检查下配置文件是否正确
    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

    如果没有报错，可以启动Nagios服务
    /usr/local/nagios/bin/nagios -d /usr/local/nagios/etc/nagios.cfg
    
    其他命令
    /etc/init.d/nagios restart
    /etc/init.d/nagios stop
    /etc/init.d/nagios start
    /etc/init.d/nagios status

    查看Nagios运行状态
    /usr/local/nagios/bin/nagiostats
    
    重启nginx
    /usr/local/nginx/sbin/nginx -s reload
    
    打开浏览器查看监控情况
    http://192.168.56.10/
    
12.监控特定端口
    a) vi /usr/local/nagios/etc/objects/commands.cfg
    
    增加一下内容
# check port 22122
define command{
	command_name    22122
	command_line    $USER1$/check_tcp -H $HOSTADDRESS$ -p 22122 $ARG2$
	}
    b) vi /usr/local/nagios/etc/objects/localhost.cfg
    
    增加一下内容
    
    define service{
        use                            local-service         ; Name of service template to use
        host_name                      localhost
        service_description            22122
        check_command                  22122
        is_volatile                     0
        check_period                    24x7
        max_check_attempts              2
        normal_check_interval           1
        retry_check_interval            1
        contact_groups                  admins
        notification_options            w,u,c,r
        notification_interval           960
        notification_period             24x7
        }
        
    c) 重启nagios
    
    /etc/init.d/nagios restart
    
    d) 打开浏览器查看监控情况
    
    http://192.168.56.10/
    
13.安装NRPE（需要监控其他机器时）

    由于Nagios只能监测自己所在的主机的一些本地情况,例如，cpu负载、内存使用、硬盘使用等等。如果想要监测被监控的服务器上的这些本地情况，就要用到NRPE。NRPE(Nagios Remote Plugin Executor)是Nagios的一个扩展，它被用于被监控的服务器上，向Nagios监控平台提供该服务器的一些本地的情况。NRPE可以称为Nagios的Linux客户端。
    由于NRPE是通过SSL方式在监控和被监控主机上进行数据传输的，所以必须先安装ssl相关的软件包。

    cd /usr/local/src
    tar zxvf nrpe-2.12.tar.gz
    cd nrpe-2.12
    ./configure
    make all
    make install-plugin
    make install-daemon
    make install-daemon-config

    注：监控主机上只需要make install-plugin这一步就可以了。监控机上只要有一个check_nrpe插件用于连接被监控端nrpe的daemon就行了。

    启动NRPE
    /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d

    验证NRPE是否正确安装
    /usr/local/nagios/libexec/check_nrpe -H localhost

    注：如果成功，会返回NRPE的版本号。

14.Nagios被控端安装配置

    a) 创建Nagios用户及组

        建立Nagios账号
        /usr/sbin/useradd -m -s /sbin/nologin nagios

    b) 编译并安装Nagios插件
        cd /usr/local/src
        tar zxvf nagios-plugins-1.4.15.tar.gz
        cd nagios-plugins-1.4.15
        ./configure --with-nagios-user=nagios --with-nagios-group=nagios
        make
        make install

        验证程序是否被正确安装：
        ls /usr/local/nagios/libexec

        显示安装的插件文件,即所有的插件都安装在libexec这个目录下。

    c) 安装NRPE

        cd /usr/local/src
        tar zxvf nrpe-2.12.tar.gz
        cd nrpe-2.12
        ./configure
        make all
        make install-plugin
        make install-daemon
        make install-daemon-config

    d) 启动NRPE
        /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d

        验证NRPE是否正确安装
        /usr/local/nagios/libexec/check_nrpe -H localhost
        注：如果成功，会返回NRPE的版本号。

    e) 修改NRPE配置文件，让监控主机可以访问被监控主机的NRPE。

        缺省NRPE配置文件中只允许本机访问NRPE的Daemon
        vi /usr/local/nagios/etc/nrpe.cfg

        allowed_hosts=192.168.56.10

    f) 重启nrpe的方法
        killall nrpe
        /usr/local/nagios/bin/nrpe -c /usr/local/nagios/etc/nrpe.cfg -d


参考：
    http://www.mike.org.cn/articles/nginx-install-nagios-monitor-platform/
