

1. ��װ������
   yum -y install wget make gcc gcc-c++ perl gd-devel zlib zlib-devel openssl openssl-devel
   
2. ���ء���װ PCRE
   ˵����nginx �� http_rewrite_module ģ�飬��Ҫ PCRE ��
   �ٷ����أ�ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
   
   cd /usr/local/src
   wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.21.tar.gz
   tar -xvf pcre-8.21.tar.gz
   cd /usr/local/src/pcre-8.21
   ./configure
   make
   make install
   
3. ���ء���װ zlib ���������Ѱ�װ���Ͳ���Ҫ�ظ���װ�ˡ�
   ˵����nginx �� http_gzip_module ģ�飬��Ҫ zlib ��
   �ٷ����أ�http://zlib.net/
   
   cd /usr/local/src
   wget http://zlib.net/zlib-1.2.8.tar.gz
   tar -xvf zlib-1.2.8.tar.gz
   cd /usr/local/src/zlib-1.2.8
   ./configure
   make
   make install
  
4. ���� openssl ���������Ѱ�װ���Ͳ���Ҫ�ظ���װ�ˡ�
   ˵����nginx �� http_ssl_module ģ�飬��Ҫ openssl �⣻nginx ��װʱ�趨configure���� ./configure --with-http_ssl_module --with-openssl=/usr/local/src/openssl-1.0.1e
   �ٷ����أ�http://www.openssl.org/source/
   
   cd /usr/local/src
   wget http://www.openssl.org/source/openssl-1.0.1e.tar.gz
   tar -xvf openssl-1.0.1e.tar.gz
  
5. ���ء���װ nginx 
   ˵�����ð�װ����֧�֣�http_gzip_module http_rewrite_module http_proxy_module http_ssl_module ��Ĭ�ϰ�װĿ¼��/usr/local/nginx
   �ٷ�����:http://nginx.org/en/download.html
   
   cd /usr/local/src
   wget http://nginx.org/download/nginx-1.5.4.tar.gz
   tar -xvf nginx-1.5.4.tar.gz
   cd /usr/local/src/nginx-1.5.4
   ./configure --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_realip_module --with-http_image_filter_module --with-openssl=/usr/local/src/openssl-1.0.1e
   make
   make install
   
6. ���� nginx
   ������/usr/local/nginx/sbin/nginx
   ���أ�/usr/local/nginx/sbin/nginx -s reload
   ֹͣ��/usr/local/nginx/sbin/nginx -s stop
   
7. ����֧�� php����ѡ�Ȱ�װphp��
   
    cp  /usr/local/nginx/conf/nginx.conf.default  /usr/local/nginx/conf/nginx.conf
    �༭ nginx.conf ȥ�� ǰ�� # 
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}
    �޸� /scripts$fastcgi_script_name; Ϊ $document_root$fastcgi_script_name; 
    
    ��/usr/local/nginx/html�´���index.php�ļ���������������
    <?php echo phpinfo(); ?>

    ���� nginx��/usr/local/nginx/sbin/nginx -s reload
    
    ע����ʱ�ر�iptables��service iptables stop 
    ����������ʣ�http://192.168.56.20/index.php
   
   
==================================================================
nginx �� configure�� ��֧�����²�����

--prefix=path    ����һ��Ŀ¼����ŷ������ϵ��ļ� ��Ҳ����nginx�İ�װĿ¼��Ĭ��ʹ�� /usr/local/nginx�� 
--sbin-path=path ����nginx�Ŀ�ִ���ļ���·����Ĭ��Ϊ  prefix/sbin/nginx. 
--conf-path=path  ������nginx.conf�����ļ���·����nginx����ʹ�ò�ͬ�������ļ�������ͨ���������е�-cѡ�Ĭ��Ϊprefix/conf/nginx.conf. 
--pid-path=path  ����nginx.pid�ļ������洢�������̵Ľ��̺š���װ��ɺ󣬿�����ʱ�ı���ļ��� �� ��nginx.conf�����ļ���ʹ�� PIDָ�Ĭ������£��ļ��� Ϊprefix/logs/nginx.pid. 
--error-log-path=path ���������󣬾��棬������ļ������ơ���װ��ɺ󣬿�����ʱ�ı���ļ��� ����nginx.conf�����ļ��� ʹ�� ��error_logָ�Ĭ������£��ļ��� Ϊprefix/logs/error.log. 
--http-log-path=path  �����������HTTP����������־�ļ������ơ���װ��ɺ󣬿�����ʱ�ı���ļ��� ����nginx.conf�����ļ��� ʹ�� ��access_logָ�Ĭ������£��ļ��� Ϊprefix/logs/access.log. 
--user=name  ����nginx�������̵��û�����װ��ɺ󣬿�����ʱ���ĵ�������nginx.conf�����ļ��� ʹ�õ� userָ�Ĭ�ϵ��û�����nobody�� 
--group=name  ����nginx�������̵��û��顣��װ��ɺ󣬿�����ʱ���ĵ�������nginx.conf�����ļ��� ʹ�õ� userָ�Ĭ�ϵ�Ϊ����Ȩ�û��� 
--with-select_module --without-select_module ���û���ù���һ��ģ�������������ʹ��select()��������ģ�齫�Զ����������ƽ̨��֧�ֵ�kqueue��epoll��rtsig��/dev/poll�� 
--with-poll_module --without-poll_module ���û���ù���һ��ģ�������������ʹ��poll()��������ģ�齫�Զ����������ƽ̨��֧�ֵ�kqueue��epoll��rtsig��/dev/poll�� 
--without-http_gzip_module �� ������ѹ����HTTP����������Ӧģ�顣���벢���д�ģ����Ҫzlib�⡣ 
--without-http_rewrite_module  ��������дģ�顣���벢���д�ģ����ҪPCRE��֧�֡� 
--without-http_proxy_module �� ������http_proxyģ�顣 
--with-http_ssl_module �� ʹ��httpsЭ��ģ�顣Ĭ������£���ģ��û�б����������������д�ģ���OpenSSL���Ǳ���ġ� 
--with-pcre=path �� ����PCRE���Դ��·����PCRE���Դ�루�汾4.4 - 8.30����Ҫ��PCRE��վ���ز���ѹ������Ĺ�����Nginx��./ configure��make����ɡ�������ʽʹ����locationָ��� ngx_http_rewrite_module ģ���С� 
--with-pcre-jit ������PCRE������just-in-time compilation����1.1.12�У� pcre_jitָ��� 
--with-zlib=path �����õ�zlib���Դ��·����Ҫ���ش� zlib���汾1.1.3 - 1.2.5���Ĳ���ѹ������Ĺ�����Nginx��./ configure��make��ɡ�ngx_http_gzip_moduleģ����Ҫʹ��zlib �� 
--with-cc-opt=parameters �� ���ö���Ĳ���������ӵ�CFLAGS����������,������FreeBSD��ʹ��PCRE��ʱ��Ҫʹ��:--with-cc-opt="-I /usr/local/include��.����Ҫ��Ҫ���� select()֧�ֵ��ļ�����:--with-cc-opt="-D FD_SETSIZE=2048". 
--with-ld-opt=parameters �����ø��ӵĲ������������������ڼ䡣���磬����FreeBSD��ʹ�ø�ϵͳ��PCRE��,Ӧָ��:--with-ld-opt="-L /usr/local/lib". 
