
svn服务器架设：

1. 硬盘raid问题。在安装的时候。按 TAB 编辑第一个。输入 nodmraid 然后安装
2. 选择的是最精简的无桌面的安装模式
3. 进入系统后，要开启网卡开机启动。编辑 /etc/sysconfig/network-script/ifcfg-eth0
4. 安装依赖包
yum install gcc gcc-c++ make wget openssl-devel openssh-clients

5. svn服务器安装

将 subversion-1.6.6.tar.gz 和 subversion-deps-1.6.6.tar.gz 传到 /usr/local/src 目录

cd /usr/local/src
tar -zxvf subversion-1.6.6.tar.gz
tar -zxvf subversion-deps-1.6.6.tar.gz
cd subversion-1.6.6
./configure --prefix=/usr/local/svn --without-berkeley-db

(注：以svnserve方式运行，不加apache编译参数。以fsfs格式存储版本库，不编译berkeley-db)

# make 
# make install

在/etc/profile最后加入 SVN Path 以方便操作：

# vi /etc/profile

PATH=$PATH:/usr/local/svn/bin
export PATH

重载配置文件
source /etc/profile

测试是否安装成功：

# svnserve --version	
如果出现： -bash: svnserve: command not found   直接重启下服务器：reboot

或
# /usr/local/svn/bin/svnserve --version

# svnserve --version
如果显示如下，svn安装成功:
svnserve, version 1.6.6 (r40053)
   compiled Feb 16 2012, 11:00:23

Copyright (C) 2000-2009 CollabNet.
Subversion is open source software, see http://subversion.tigris.org/
This product includes software developed by CollabNet (http://www.Collab.Net/).

The following repository back-end (FS) modules are available:

* fs_fs : Module for working with a plain file (FSFS) repository.


6. svn配置建立svn版本库目录可建多个：
新建文件夹：
# mkdir -p /usr/local/svndata
# mkdir -p /usr/local/svndata/repos
建立svn版本库：
# svnadmin create /usr/local/svndata/repos
修改svn版本库配置文件版本库：
# vi /usr/local/svndata/repos/conf/svnserve.conf
内容修改为:

[general]
anon-access = none
auth-access = write
password-db = /usr/local/svn/conf/passwd.conf
authz-db = /usr/local/svn/conf/authz.conf
realm = repos

创建配置目录
# mkdir /usr/local/svn/conf/

配置svn用户
# vi /usr/local/svn/conf/passwd.conf

注意：对用户配置文件的修改立即生效，不必重启svn。
passwd.conf [users]是必须的，文件格式如下：
[users]
username = password #列出要访问svn的用户，每个用户一行，如：
[users]
funfly = 123456

配置svn用户访问权限：
# vi /usr/local/svn/conf/authz.conf

注意：
* 权限配置文件中出现的用户名必须已在用户配置文件中定义。
* 对权限配置文件的修改立即生效，不必重启svn。
用户组格式：
[groups]
= ,
其中，1个用户组可以包含1个或多个用户，用户间以逗号分隔。
版本库目录格式：
[<版本库>:/项目/目录]
@<用户组名> = <权限>
<用户名> = <权限>
其中，方框号内部分可以有多种写法:
[/],表示根目录及以下，根目录是svnserve启动时指定的，我们指定为/usr/local/svndata，[/]就是表示对全部版本库设置权限。
[repos:/] 表示对版本库repos设置权限
[repos2:/abc] 表示对版本库repos2中的abc项目设置权限
[repos2:/abc/aaa] 表示对版本库repos2中的abc项目的aaa目录设置权限

权限主体可以是用户组、用户或*，用户组在前面加@，*表示全部用户。
权限可以是w、r、wr和空，空表示没有任何权限。
示例：
[groups]
admin = funfly
[/]
@admin = rw
[repos1:/abc/aaa]
king = rw
[repos2:/pass]
king =
svn配置完毕。

3. 启动svn
# /usr/local/svn/bin/svnserve -d --listen-port 3000 -r /usr/local/svndata

-d表示以daemon方式（后台运行）运行
--listen-port 3000表示使用3000端口，可以换成你需要的端口。但注意，使用1024以下的端口需要root权限
-r /usr/local/svndata指定根目录是/usr/local/svndata
检查:
ps -ef|grep svnserve
如果显示如下，即为启动成功：
svn　　　 6941　　 1　0 15:07 ?　　　　00:00:00 svnserve -d --listen-port 3000 -r /usr/local/svndata
通过web方式访问svn有很多方法，请参阅配置websvn或配置bsSvnBrowser的方法。

好了所有配置完成，可以使用客户端SVN进行操作了。
服务器测试：

# cd /tmp
# mkdir test
# touch test.txt
# svn import /tmp/test/ file:///usr/local/svndata/repos -m “this is thie first import”
# mkdir -p /tmp/test2
# cd /tmp/test2
# svn co file:///usr/local/svndata/repos /tmp/test2/

或者：
# svn co svn://{your-server-ip}:3000/repos/

这时应该可以看到文件test.txt.

另外的测试方法：
# telnet {your-server-ip} 3000 检查端口是不是通的
如果 上面检查不通，有可能是iptables中没有打开，设置iptables就可以：
# vi /etc/sysconfig/iptables
添加：

-A RH-Firewall-1-INPUT -p tcp --dport 3000 -j ACCEPT

或者直接停用 iptables 
# service iptables stop



==========================================
svn 异常自动重启，请直接运行：
tool/svnAutoStartInstall.sh
==========================================



[安装crontab]
服务器是centOS,安装
yum -y install vixie-cron crontabs
service crond start //启动服务
service crond stop //关闭服务
service crond restart //重启服务
service crond reload //重新载入配置
[编辑]
crontab -e
service crond restart //重启服务
[查看]
crontab -l

0 3 * * * /home/crontab/sh/Bakdata.sh






二、svn服务与apache 整合
Subversion存储方式，一是Berkeley DB伯克利存储方式，二是fsfs存储方式。
两种版本库数据存储对照表
特性 Berkeley DB FSFS
对操作中断的敏感 很敏感；系统崩溃或者权限问题会导致数据库“塞住”，需要定期进行恢复。 不敏感
可只读加载 不能 可以
存储平台无关 不能 可以
可从网络文件系统访问 不能 可以
版本库大小 稍大 稍小
扩展性：修订版本树数量 无限制 某些本地文件系统在处理单一目录包含上千个条目时会出现问题。
扩展性：文件较多的目录 较慢 较慢
检出最新代码的速度 较快 可以
大量提交的速度 较慢，但时间被分配在整个提交操作中 较快，但最后较长的延时可能会导致客户端操作超时
组访问权处理 对于用户的 umask 设置十分敏感，最好只由一个用户访问。 对 umask 设置不敏感
功能成熟时间 2001 年 2004 年


1、安装APR-1.2.7和APR-util-1.2.7

    下载地址：[url]http://apr.apache.org/ [/url]

    tar zxvf apr-1.2.7.tar.gz

   ./configure

    make

    make install

    tar zxvf apr-util-1.2.7.tar.gz

    ./configure --with-apr=/usr/local/apr/

     make

     make install

2、编译安装APACHE。

    tar zxvf httpd-2.2.3.tar.gz
    cd httpd-2.2.3
   ./configure --prefix=/home/apache --enable-dav --enable-so --enable-maintainer-mode --with-apr=/usr/local/apr/bin/apr-1-config --with-apr-util=/usr/local/apr/bin/apu-1-config

     make
     make install

3、安装subversion-1.4.0

     tar zxvf subversion-1.4.0.tar.gz

./configure --with-apxs=/home/apache/bin/apxs --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr
问题：有关共享库错误
方法： echo "/usr/local/apr-util/lib" >> /etc/ld.so.c
            ldconfig      echo $?


make
    make install
   设置环境变量（可做可不做）
vi /etc/profile,在/etc/profile最后加入:
PATH=$PATH:/usr/local/svn/bin
export PATH

4、查看subversion两个动态库有没有安装成功

     vi /home/apache/conf/httpd.conf

    看到下面两个模块说明安装成功

     LoadModule dav_svn_module     modules/mod_dav_svn.so
     LoadModule authz_svn_module   modules/mod_authz_svn.so

5、配置SVN

    vi /home/apache/conf/httpd.conf

     配置：

    <Location /svn>
       DAV svn
        SVNParentPath /data/svn/repos //svn父目录
        AuthType Basic //连接类型设置
        AuthName "Subversion repository" //连接框提示
        AuthUserFile /data/svn/passwd //用户配置文件
        AuthzSVNAccessFile /data/svn/auth
        Require valid-user //passwd所有的用户都可以访问
</Location>

6、建立SVN存储仓库

     #mkdir -p /usr/local/svndata/repos

    #svnadmin create –fs-type fsfs /usr/local/svndata/repos

备份以前的SVN库

#svnadmin dump /usr/local/svndata/repos > /root/repos20080328

把备份出来的数据恢复到本地

#svnadmin load /usr/local/svndata/repos/ < /root/repos20080328

7、建立本地访问控制文件
#/home/apache/bin/htpasswd [-c] /home/passwd north
//第一次设置用户时使用-c表示新建一个用户文件。#/home/apache/bin/htpasswd passwd 用户名(加入新的用户)


8、建立本地项目控制文件

    touch /usr/local/svndata/auth

    文件内容为：

[groups]
[repos1:/]
#wxy = rw
north = rw
tom = rw


[repos2:/]
repos2 = rw


9、安装客户端，访问服务器

   [url]http://192.168.0.180:/svn/jishu[/url]
   注意：SVN是APACHE配置的时候加上去的。

10、到此安装基本结束

     修改一下/data/svn/repos属性，否则会导致文件上传失败。

     chmod -R apache.apache repos

三、日常维护命令和参数

启动svn服务
svnserve -d --listen-port 20000 -r /usr/local/svndata


创建版本库
svnadmin create fs-type fsfs /usr/local/svndata/mark


查看版本库的信息
svn list file:///usr/local/svndata/mark
svn list --verbose file:///usr/local/svndata/mark

导入库的目录结构
svn import /tmp/mark/ file:///usr/local/svndata/mark/ --message "init" (文件夹mark下有bo)


删除版本库mark下文件夹bo
svn delete svn://192.168.0.180:20000/usr/local/svndata/mark/bo -m "delete "


//导出
$svnlook youngest oldrepo
$svnadmin dump oldrepo >; dumpfile

//还原
$svnadmin load newrepo < dumpfile

停止subversion服务
ps -aux|grep svnserve
kill -9 ID号




