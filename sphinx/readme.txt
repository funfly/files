
1. ��װ������
   yum -y install gcc mysql-server mysql-devel make wget
  
2. ���ء���ѹ����װ sphinx-for-chinese ���ٷ����ص�ַ��http://sphinx-for-chinese.googlecode.com/files/sphinx-for-chinese-2.1.0-dev-r3361.tar.bz2��
   cd /usr/local/src
   wget http://sphinx-for-chinese.googlecode.com/files/sphinx-for-chinese-2.1.0-dev-r3361.tar.bz2
   tar -xvf sphinx-for-chinese-2.1.0-dev-r3361.tar.bz2
   cd /usr/local/src/sphinx-for-chinese-2.1.0-dev-r3361
   ./configure --prefix=/usr/local/sphinx-for-chinese
   make
   make install
   
3. ���ء���ѹ����װ xdict ���ٷ����ص�ַ��http://sphinx-for-chinese.googlecode.com/files/xdict_1.1.tar.gz��
   cd /usr/local/src
   wget http://sphinx-for-chinese.googlecode.com/files/xdict_1.1.tar.gz
   tar -xvf xdict_1.1.tar.gz
   /usr/local/sphinx-for-chinese/bin/mkdict xdict_1.1.txt xdict #��xdict_1.1.txt����xdict�ļ���xdict_1.1.txt�ļ����Ը�����Ҫ�����޸�
   cp xdict /usr/local/sphinx-for-chinese/etc/

4. �޸� vi /usr/local/etc/sphinx.conf ���������ļ�
   �������������������������
   charset_type = utf-8
   chinese_dictionary = /usr/local/sphinx-for-chinese/etc/xdict
   ����Ŀ¼��
   mkdir /var/data/

5. ���ã�mysql 
   vi /etc/my.cnf �м��� default-character-set=utf8
   ������mysql 
   service mysqld start����/etc/init.d/mysqld start
   �������ݣ�
   mysql -utest < /usr/local/sphinx-for-chinese/etc/example.sql
   ���ߣ�
   mysql -utest -p
   source /usr/local/sphinx-for-chinese/etc/example.sql

6. ����
   /usr/local/sphinx-for-chinese/bin/indexer --all  //��������
   /usr/local/sphinx-for-chinese/bin/search test    //�����Ƿ�ɹ�
   ע�⣺index 'testrt': search error: failed to open /var/data/testrt.sph: No such file or directory. �����ʵʱ����������ģ����������뿴���棻
   /usr/local/sphinx-for-chinese/bin/searchd        //��������

7. ����ʵʱ������
   mysql -h192.168.56.10 -uroot -p -P9306 --protocol=tcp
   show tables;
   desc testrt;
   
8. �����µ�ʵʱ������
   vi /usr/local/etc/sphinx.conf ����һ�����ݣ�
   
index weibo_content
{
        type                    = rt
        rt_mem_limit            = 32M

        path                    = /var/data/weibo_content
        charset_type            = utf-8

        chinese_dictionary      = /usr/local/sphinx-for-chinese/etc/xdict
        rt_field                = content
        rt_attr_uint            = scope_flag
        rt_attr_uint            = scope_id
}

9. ���� sphinx
   ֹͣ sphinx : /usr/local/sphinx-for-chinese/bin/searchd --stop
   ���� sphinx:  /usr/local/sphinx-for-chinese/bin/searchd

10.�����µ�ʵʱ������
   mysql -h192.168.56.10 -uroot -p -P9306 --protocol=tcp
   use weibo_content;
   insert into weibo_content(id,content,scope_flag,scope_id)values(11,'�������',11,1);
   insert into weibo_content(id,content,scope_flag,scope_id)values(12,'����������',12,2);
   insert into weibo_content(id,content,scope_flag,scope_id)values(13,'�й���ɫ������������',13,3);
   insert into weibo_content(id,content,scope_flag,scope_id)values(14,'��������й���ɫ������������',14,4);
   
   ������
   SELECT * FROM `weibo_content` WHERE MATCH('�й�');
   SELECT * FROM `weibo_content` WHERE MATCH('�й�') AND `scope_id` <= 3 ;
   SELECT * FROM `weibo_content` WHERE MATCH('�й���ɫ');
   

ע�⣺
   1. �����������ʾ content �ֶ����ݣ��ֶ�����Ϊ��rt_field
   2. �������ķִ����⡣���ܵ��¹ؼ����޷�ƥ�䡣
   3. sphinxʵʱ��������mysql��ѯ��䡣ʹ��������mysql���в����ο���10���sql��䡣
   4. PHP�����ļ�����ʹ�� utf8����
   5. �����в����PHP����Ĳ��룬�������ڱ������ⲻ���ݡ��޷��õ���ѯ�����
   
�ο���
   http://log.medcl.net/item/2012/06/sphinx-installation-to-use/
   http://www.sphinx-search.com/
   http://hot66hot.iteye.com/blog/1759559
   http://www.linuxde.net/2013/03/13105.html    ���ֲ�ʽ������
