
1. ��װ������
   yum -y install gcc wget make
   
2. ���ء���ѹ����װ redis    �����ص�ַ��https://code.google.com/p/redis/downloads/list��
   cd /usr/local/src
   wget https://redis.googlecode.com/files/redis-2.6.14.tar.gz
   tar -xvf redis-2.6.14.tar.gz
   mv redis-2.6.14 /usr/local/redis 
   cd /usr/local/redis 
   make
   make install

3. ��������Ŀ¼��������redis
   mkdir /home/redis
   �� conf-10/redis.conf �ϴ�����/usr/local/redis/
   
4. ����redis
   /usr/local/redis/src/redis-server /usr/local/redis/redis.conf
   /usr/local/redis/src/redis-server /usr/local/redis/redis.conf --slaveof 192.168.56.10 6379
   ��֤����״̬��netstat -ntl ���� ps -aux|grep redis
   
5. ����������

   ��������
   chmod 700 /etc/init.d/redis
   chkconfig --add redis
   service redis start

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
   �� phpredis-master.tar �ϴ��� /usr/local/src
   cd /usr/local/src
   tar -xvf phpredis-master.tar
   cd phpredis-master
   /usr/local/php/bin/phpize
   ./configure --with-php-config=/usr/local/php/bin/php-config
   make && make install
   
   �޸�php.ini
   vi /usr/local/php/etc/php.ini
   ���룺
   extension = "redis.so"
   
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
   http://www.springload.cn/springload/detail/471
   http://blog.haohtml.com/archives/10385
   http://www.cnblogs.com/weafer/archive/2011/09/21/2184059.html
   

   

