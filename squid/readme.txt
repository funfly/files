
1. ��װ������
   yum -y install gcc wget perl gcc-c++ make
   
2. ���ء���ѹ����װ squid
   cd /usr/local/src
   wget http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.19.tar.gz
   tar -xvf squid-3.1.19.tar.gz
   cd /usr/local/src/squid-3.1.19
   ./configure
   make
   make install
   
3. ���� squid 
   groupadd squid
   useradd -g squid -s /sbin/nologin squid
   
4. ����cacheĿ¼
   mkdir /usr/local/squid/var/cache
   chown 777 -R /usr/local/squid/var/

5. ����squid.conf
   �����úõ� squid.conf ���ǵ� /usr/local/squid/etc/

6. ��֤squid.conf�����Ƿ���ȷ
   /usr/local/squid/sbin/squid -Nk parse
 
7. ���ɻ���Ŀ¼
   /usr/local/squid/sbin/squid -N -z
   
8. ����squid
   /usr/local/squid/sbin/squid
   
9. �鿴squid�����Ƿ��������Ƿ����80
   ps aux|grep squid
   netstat -an|grep 80
   netstat -ntl
   
10.��֤squid ����״̬
   ��host: 192.168.56.10   www.test.com
   ע�⿪�Ŷ˿ڻ���ʱ�ر�192.168.56.10��192.168.56.11��iptables: service iptables stop �����޷�����
   ��IE���ʣ�www.test.com
   
11.squid���
   ���¼��������ļ���
   /usr/local/squid/sbin/squid �Ck reconfigure 
   
   ����squid���̣�
   /usr/local/squid/sbin/squid �Ck shutdown

   ȡ��squid����״̬��Ϣ��  
   /usr/local/squid/bin/squidclient -p 80 mgr:info

   ȡ��squid�ڴ�ʹ�������  
   /usr/local/squid/bin/squidclient -p 80 mgr:mem

   ȡ��squid�Ѿ�������б� 
   /usr/local/squid/bin/squidclient -p 80 mgrbjects. use it carefully,it may crash

   ȡ��squid�Ĵ���ʹ�������  
   /usr/local/squid/bin/squidclient -p 80 mgr:diskd

   ǿ�Ƹ���ĳ��url��  
   /usr/local/squid/bin/squidclient -p 80 -m PURGE http://www.test.com/

   �������ʣ� 
   /usr/local/squid/bin/squidclient -h�����IP -p80 mgr:info
   /usr/local/squid/bin/squidclient -h192.168.56.11 -p80 mgr:info

12.�鿴�����־�ĵ���
    
   ###��ָ����Կ�����squid���й����У�����Щ�ļ���squid���浽�ڴ��У������ظ������û���
   more /usr/local/squid/var/logs/access.log | grep TCP_MEM_HIT
    
   ###��ָ����Կ�����squid���й����У�����Щ�ļ���squid���浽cacheĿ¼�У������ظ������û���
   more /usr/local/squid/var/logs/access.log | grep TCP_HIT
    
   ###��ָ����Կ�����squid���й����У�����Щ�ļ�û�б�squid���棬��������ԭʼ��������ȡ�����ظ������û���
   more /usr/local/squid/var/logs/access.log | grep TCP_MISS
    
�ο���
    http://www.centos.bz/2012/05/squid-reverse-proxy-deploy/
    http://zhumeng8337797.blog.163.com/blog/static/10076891420114933258955/
    http://netsecurity.51cto.com/art/201209/357254.htm
    http://www.net527.cn/a/caozuoxitong/Linux/2012/0508/22854.html
    http://hi.baidu.com/jemmychen/item/25c8b8b43c5db875254b09a7
