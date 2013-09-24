
1. 安装依赖包
   yum -y install gcc mysql-server mysql-devel make wget
  
2. 下载、解压、安装 sphinx-for-chinese 【官方下载地址：http://sphinx-for-chinese.googlecode.com/files/sphinx-for-chinese-2.1.0-dev-r3361.tar.bz2】
   cd /usr/local/src
   wget http://sphinx-for-chinese.googlecode.com/files/sphinx-for-chinese-2.1.0-dev-r3361.tar.bz2
   tar -xvf sphinx-for-chinese-2.1.0-dev-r3361.tar.bz2
   cd /usr/local/src/sphinx-for-chinese-2.1.0-dev-r3361
   ./configure --prefix=/usr/local/sphinx-for-chinese
   make
   make install
   
3. 下载、解压、安装 xdict 【官方下载地址：http://sphinx-for-chinese.googlecode.com/files/xdict_1.1.tar.gz】
   cd /usr/local/src
   wget http://sphinx-for-chinese.googlecode.com/files/xdict_1.1.tar.gz
   tar -xvf xdict_1.1.tar.gz
   /usr/local/sphinx-for-chinese/bin/mkdict xdict_1.1.txt xdict #从xdict_1.1.txt生成xdict文件，xdict_1.1.txt文件可以根据需要进行修改
   cp xdict /usr/local/sphinx-for-chinese/etc/

4. 修改 vi /usr/local/etc/sphinx.conf 索引配置文件
   在索引配置项中添加以下两项
   charset_type = utf-8
   chinese_dictionary = /usr/local/sphinx-for-chinese/etc/xdict
   创建目录：
   mkdir /var/data/

5. 配置：mysql 
   vi /etc/my.cnf 中加入 default-character-set=utf8
   启动：mysql 
   service mysqld start或者/etc/init.d/mysqld start
   导入数据：
   mysql -utest < /usr/local/sphinx-for-chinese/etc/example.sql
   或者：
   mysql -utest -p
   source /usr/local/sphinx-for-chinese/etc/example.sql

6. 启动
   /usr/local/sphinx-for-chinese/bin/indexer --all  //建立索引
   /usr/local/sphinx-for-chinese/bin/search test    //测试是否成功
   注意：index 'testrt': search error: failed to open /var/data/testrt.sph: No such file or directory. 这个是实时索引表引起的，不管它，请看下面；
   /usr/local/sphinx-for-chinese/bin/searchd        //启动服务

7. 测试实时索引：
   mysql -h192.168.56.10 -uroot -p -P9306 --protocol=tcp
   show tables;
   desc testrt;
   
8. 创建新的实时索引表：
   vi /usr/local/etc/sphinx.conf 增加一下内容：
   
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

9. 重启 sphinx
   停止 sphinx : /usr/local/sphinx-for-chinese/bin/searchd --stop
   启动 sphinx:  /usr/local/sphinx-for-chinese/bin/searchd

10.测试新的实时索引表：
   mysql -h192.168.56.10 -uroot -p -P9306 --protocol=tcp
   use weibo_content;
   insert into weibo_content(id,content,scope_flag,scope_id)values(11,'社会主义',11,1);
   insert into weibo_content(id,content,scope_flag,scope_id)values(12,'社会主义社会',12,2);
   insert into weibo_content(id,content,scope_flag,scope_id)values(13,'中国特色的社会主义社会',13,3);
   insert into weibo_content(id,content,scope_flag,scope_id)values(14,'建设具有中国特色的社会主义社会',14,4);
   
   搜索：
   SELECT * FROM `weibo_content` WHERE MATCH('中国');
   SELECT * FROM `weibo_content` WHERE MATCH('中国') AND `scope_id` <= 3 ;
   SELECT * FROM `weibo_content` WHERE MATCH('中国特色');
   

注意：
   1. 搜索结果不显示 content 字段内容，字段类型为：rt_field
   2. 由于中文分词问题。可能导致关键词无法匹配。
   3. sphinx实时索引兼容mysql查询语句。使用起来跟mysql略有差别；请参考第10点的sql语句。
   4. PHP程序文件必须使用 utf8编码
   5. 命令行插入跟PHP程序的插入，可能由于编码问题不兼容。无法得到查询结果。
   
参考：
   http://log.medcl.net/item/2012/06/sphinx-installation-to-use/
   http://www.sphinx-search.com/
   http://hot66hot.iteye.com/blog/1759559
   http://www.linuxde.net/2013/03/13105.html    【分布式索引】
