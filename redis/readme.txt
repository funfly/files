
1. ��װ������
   yum -y install gcc wget make tcl
   
2. ���ء���ѹ����װ redis    �����ص�ַ��http://redis.io/download��
   cd /usr/local/src
   wget http://download.redis.io/releases/redis-2.6.16.tar.gz
   tar -xvf redis-2.6.16.tar.gz
   mv redis-2.6.16 /usr/local/redis 
   cd /usr/local/redis 
   make
   make install

3. ��������Ŀ¼��������redis
   mkdir /home/redis
   �� conf-10/redis.conf �ϴ�����/usr/local/redis/
   
4. ����redis
   vi /usr/local/redis/redis.conf
   �޸ģ�daemaon no Ϊdaemaon yes
   
   /usr/local/redis/src/redis-server /usr/local/redis/redis.conf
   /usr/local/redis/src/redis-server /usr/local/redis/redis.conf --slaveof 192.168.56.10 6379
   ��֤����״̬��netstat -ntl ���� ps -aux|grep redis
   
5. ����������

   #�����Ƿ�������
   /usr/local/redis/src/redis-cli ping
   /usr/local/redis/src/redis-cli -h 192.168.56.10 ping #���ض�IP����ʹ�ø�����
   #���ܲ���
   /usr/local/redis/src/redis-benchmark
   #�رշ���
   /usr/local/redis/src/redis-cli shutdown                          #�ر�����
   /usr/local/redis/src/redis-cli -h 192.168.56.10 shutdown         #�ر����� ���ض�IP����ʹ�ø�����
   /usr/local/redis/src/redis-cli -p 6397 shutdown                  #�ر�6397�˿ڵ�redis
  
   #ǿ��ˢ�����ݵ����̡�RedisĬ�����첽д����̵ġ�
    /usr/local/redis/src/redis-cli -p6379 save

6. ����redis
   /usr/local/redis/src/redis-cli -h 192.168.56.10 set test 'hi...'
   /usr/local/redis/src/redis-cli -h 192.168.56.10 get test

7. ��װphp redis��չ

    wget https://github.com/nicolasff/phpredis/zipball/master -O php-redis.zip
    unzip php-redis.zip
    cd nicolasff-phpredis-504724b/
    /usr/local/php/bin/phpize
    ./configure --with-php-config=/usr/local/php/bin/php-config
    make && make install

   �޸�php.ini
   vi /usr/local/php/etc/php.ini
   ���룺
   extension=redis.so
   
   ���� php-fpm
   /usr/local/php/sbin/php-fpm restart
   
   �鿴 phpinfo ��֤ redis ��չ�Ƿ�װ�ɹ�
   http://192.168.56.12/phpinfo.php
   
8. ���� redis ����
   �� conf-10/redis.conf �ϴ��� 192.168.56.10 �������� /usr/local/redis/ Ŀ¼�������� reids ��master��
   �� conf-11/redis.conf �ϴ��� 192.168.56.11 �������� /usr/local/redis/ Ŀ¼�������� reids ��slave��
   �鿴���Է���������־��
   tail -f /var/log/redis.log
   
9. redis �߿����� ����ת�Ʒ����뿴Ŀ¼��redis-ha   

�ο���
   http://www.nginx.cn/tag/redis
   http://www.springload.cn/springload/detail/471
   http://blog.haohtml.com/archives/10385
   http://www.cnblogs.com/weafer/archive/2011/09/21/2184059.html
   

   

