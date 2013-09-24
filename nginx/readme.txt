

1. 安装依赖包
   yum -y install wget make gcc gcc-c++ perl gd-devel zlib zlib-devel openssl openssl-devel
   
2. 下载、安装 PCRE
   说明：nginx 的 http_rewrite_module 模块，需要 PCRE 库
   官方下载：ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
   
   cd /usr/local/src
   wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.21.tar.gz
   tar -xvf pcre-8.21.tar.gz
   cd /usr/local/src/pcre-8.21
   ./configure
   make
   make install
   
3. 下载、安装 zlib 【依赖包已安装，就不需要重复安装了】
   说明：nginx 的 http_gzip_module 模块，需要 zlib 库
   官方下载：http://zlib.net/
   
   cd /usr/local/src
   wget http://zlib.net/zlib-1.2.8.tar.gz
   tar -xvf zlib-1.2.8.tar.gz
   cd /usr/local/src/zlib-1.2.8
   ./configure
   make
   make install
  
4. 下载 openssl 【依赖包已安装，就不需要重复安装了】
   说明：nginx 的 http_ssl_module 模块，需要 openssl 库；nginx 安装时设定configure命令 ./configure --with-http_ssl_module --with-openssl=/usr/local/src/openssl-1.0.1e
   官方下载：http://www.openssl.org/source/
   
   cd /usr/local/src
   wget http://www.openssl.org/source/openssl-1.0.1e.tar.gz
   tar -xvf openssl-1.0.1e.tar.gz
  
5. 下载、安装 nginx 
   说明：该安装方法支持：http_gzip_module http_rewrite_module http_proxy_module http_ssl_module ；默认安装目录：/usr/local/nginx
   官方下载:http://nginx.org/en/download.html
   
   cd /usr/local/src
   wget http://nginx.org/download/nginx-1.5.4.tar.gz
   tar -xvf nginx-1.5.4.tar.gz
   cd /usr/local/src/nginx-1.5.4
   ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_image_filter_module --with-openssl=/usr/local/src/openssl-1.0.1e
   make
   make install
   
6. 管理 nginx
   启动：/usr/local/nginx/sbin/nginx
   重载：/usr/local/nginx/sbin/nginx -s reload
   停止：/usr/local/nginx/sbin/nginx -s stop
   
7. 配置支持 php【必选先安装php】
   
    cp  /usr/local/nginx/conf/nginx.conf.default  /usr/local/nginx/conf/nginx.conf
    编辑 nginx.conf 去掉 前面 # 
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}
    修改 /scripts$fastcgi_script_name; 为 $document_root$fastcgi_script_name; 
    
    在/usr/local/nginx/html下创建index.php文件，输入如下内容
    <?php echo phpinfo(); ?>

    重启 nginx：/usr/local/nginx/sbin/nginx -s reload
    
    注意临时关闭iptables：service iptables stop 
    打开浏览器访问：http://192.168.56.20/index.php
   
   
==================================================================
nginx 的 configure命 令支持以下参数：

--prefix=path    定义一个目录，存放服务器上的文件 ，也就是nginx的安装目录。默认使用 /usr/local/nginx。 
--sbin-path=path 设置nginx的可执行文件的路径，默认为  prefix/sbin/nginx. 
--conf-path=path  设置在nginx.conf配置文件的路径。nginx允许使用不同的配置文件启动，通过命令行中的-c选项。默认为prefix/conf/nginx.conf. 
--pid-path=path  设置nginx.pid文件，将存储的主进程的进程号。安装完成后，可以随时改变的文件名 ， 在nginx.conf配置文件中使用 PID指令。默认情况下，文件名 为prefix/logs/nginx.pid. 
--error-log-path=path 设置主错误，警告，和诊断文件的名称。安装完成后，可以随时改变的文件名 ，在nginx.conf配置文件中 使用 的error_log指令。默认情况下，文件名 为prefix/logs/error.log. 
--http-log-path=path  设置主请求的HTTP服务器的日志文件的名称。安装完成后，可以随时改变的文件名 ，在nginx.conf配置文件中 使用 的access_log指令。默认情况下，文件名 为prefix/logs/access.log. 
--user=name  设置nginx工作进程的用户。安装完成后，可以随时更改的名称在nginx.conf配置文件中 使用的 user指令。默认的用户名是nobody。 
--group=name  设置nginx工作进程的用户组。安装完成后，可以随时更改的名称在nginx.conf配置文件中 使用的 user指令。默认的为非特权用户。 
--with-select_module --without-select_module 启用或禁用构建一个模块来允许服务器使用select()方法。该模块将自动建立，如果平台不支持的kqueue，epoll，rtsig或/dev/poll。 
--with-poll_module --without-poll_module 启用或禁用构建一个模块来允许服务器使用poll()方法。该模块将自动建立，如果平台不支持的kqueue，epoll，rtsig或/dev/poll。 
--without-http_gzip_module — 不编译压缩的HTTP服务器的响应模块。编译并运行此模块需要zlib库。 
--without-http_rewrite_module  不编译重写模块。编译并运行此模块需要PCRE库支持。 
--without-http_proxy_module — 不编译http_proxy模块。 
--with-http_ssl_module — 使用https协议模块。默认情况下，该模块没有被构建。建立并运行此模块的OpenSSL库是必需的。 
--with-pcre=path — 设置PCRE库的源码路径。PCRE库的源码（版本4.4 - 8.30）需要从PCRE网站下载并解压。其余的工作是Nginx的./ configure和make来完成。正则表达式使用在location指令和 ngx_http_rewrite_module 模块中。 
--with-pcre-jit —编译PCRE包含“just-in-time compilation”（1.1.12中， pcre_jit指令）。 
--with-zlib=path —设置的zlib库的源码路径。要下载从 zlib（版本1.1.3 - 1.2.5）的并解压。其余的工作是Nginx的./ configure和make完成。ngx_http_gzip_module模块需要使用zlib 。 
--with-cc-opt=parameters — 设置额外的参数将被添加到CFLAGS变量。例如,当你在FreeBSD上使用PCRE库时需要使用:--with-cc-opt="-I /usr/local/include。.如需要需要增加 select()支持的文件数量:--with-cc-opt="-D FD_SETSIZE=2048". 
--with-ld-opt=parameters —设置附加的参数，将用于在链接期间。例如，当在FreeBSD下使用该系统的PCRE库,应指定:--with-ld-opt="-L /usr/local/lib". 
