
1. 安装依赖包
   yum -y install gcc wget perl gcc-c++ make
   
2. 下载、解压、安装 squid
   cd /usr/local/src
   wget http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.19.tar.gz
   tar -xvf squid-3.1.19.tar.gz
   cd /usr/local/src/squid-3.1.19
   ./configure
   make
   make install
   
3. 创建 squid 
   groupadd squid
   useradd -g squid -s /sbin/nologin squid
   
4. 创建cache目录
   mkdir /usr/local/squid/var/cache
   chown 777 -R /usr/local/squid/var/

5. 配置squid.conf
   将配置好的 squid.conf 覆盖到 /usr/local/squid/etc/

6. 验证squid.conf配置是否正确
   /usr/local/squid/sbin/squid -Nk parse
 
7. 生成缓存目录
   /usr/local/squid/sbin/squid -N -z
   
8. 启动squid
   /usr/local/squid/sbin/squid
   
9. 查看squid进程是否启动，是否监听80
   ps aux|grep squid
   netstat -an|grep 80
   netstat -ntl
   
10.验证squid 运行状态
   做host: 192.168.56.10   www.test.com
   注意开放端口或暂时关闭192.168.56.10和192.168.56.11的iptables: service iptables stop 否则无法访问
   打开IE访问：www.test.com
   
11.squid命令：
   重新加载配置文件：
   /usr/local/squid/sbin/squid –k reconfigure 
   
   结束squid进程：
   /usr/local/squid/sbin/squid –k shutdown

   取得squid运行状态信息：  
   /usr/local/squid/bin/squidclient -p 80 mgr:info

   取得squid内存使用情况：  
   /usr/local/squid/bin/squidclient -p 80 mgr:mem

   取得squid已经缓存的列表： 
   /usr/local/squid/bin/squidclient -p 80 mgrbjects. use it carefully,it may crash

   取得squid的磁盘使用情况：  
   /usr/local/squid/bin/squidclient -p 80 mgr:diskd

   强制更新某个url：  
   /usr/local/squid/bin/squidclient -p 80 -m PURGE http://www.test.com/

   查命中率： 
   /usr/local/squid/bin/squidclient -h具体的IP -p80 mgr:info
   /usr/local/squid/bin/squidclient -h192.168.56.11 -p80 mgr:info

12.查看你的日志文档。
    
   ###该指令可以看到在squid运行过程中，有哪些文件被squid缓存到内存中，并返回给访问用户。
   more /usr/local/squid/var/logs/access.log | grep TCP_MEM_HIT
    
   ###该指令可以看到在squid运行过程中，有哪些文件被squid缓存到cache目录中，并返回给访问用户。
   more /usr/local/squid/var/logs/access.log | grep TCP_HIT
    
   ###该指令可以看到在squid运行过程中，有哪些文件没有被squid缓存，而是现重原始服务器获取并返回给访问用户。
   more /usr/local/squid/var/logs/access.log | grep TCP_MISS
    
参考：
    http://www.centos.bz/2012/05/squid-reverse-proxy-deploy/
    http://zhumeng8337797.blog.163.com/blog/static/10076891420114933258955/
    http://netsecurity.51cto.com/art/201209/357254.htm
    http://www.net527.cn/a/caozuoxitong/Linux/2012/0508/22854.html
    http://hi.baidu.com/jemmychen/item/25c8b8b43c5db875254b09a7
