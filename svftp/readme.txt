yum -y install vsftpd

/etc/vsftpd/ftpusers  存放不能用于ftp登录的用户

创建专门的FTP用户
useradd ftpuser
设置
passwd ftpuser

限制目录：
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list

另外再创建文件/etc/vsftpd.chroot_list，并添加需要屏蔽的用户。
vi /etc/vsftpd.chroot_list
内容：
ftpuser



=====================================

/etc/vsftpd/vsftpd.conf 文件配置：

1、默认配置：

anonymous_enable=YES #允许匿名用户访问

local_enable=YES #允许本地用户访问

write_enable=YES #具有写权限

local_umask=022 #本地用户创建文件或目录的掩码

connect_from_port_20=YES #开启20端口

2、允许匿名用户具有写权限（上传／创建目录）

在默认配置下添加以下内容：

anon_upload_enable=YES

anon_mkdir_write_enable=YES

anon_world_readable_only=NO 允许匿名帐号写 另外还需具有所有权限的目录

3、屏蔽本地所有用户浏览其他目录的权限（除了家目录，匿名用户本身只能访问家目录）

在默认配置下添加以下内容：

chroot_local_user=YES

4、屏蔽部分本地用户浏览其他目录的权限

在默认配置下添加以下内容：

chroot_local_user=NO

chroot_list_enable=YES

chroot_list_file=/etc/vsftpd.chroot_list

另外再创建文件/etc/vsftpd.chroot_list，并添加需要屏蔽的用户。

5、性能选项

idle_session_timeout=600

data_connection_timeout=120

local_max_rate=50000 #本地用户的最高速率

anon_max_rate=30000
#匿名用户的最高速率

修改/etc/passwd文件的用户家目录可以改变用户登录的目录

修改/etc/passwd文件的用户的登录shell为/sbin/nologin，则不能用于本地登录，可以用于ftp登录。

/etc/xinetd.d/vsftpd文件的主要内容：（“=”前后有空格）

only_from = 192.168.1.1|192.168.1.0/24 #只接收来至某ip或网段

no_access = 192.168.3.2|192.168.3.0/24 #拒绝接收来至某ip或网段

access_times = 8:00-17:00 #设置访问时间

instances = 200 #设置最大连接数

per_source = 5 #设置每个ip可有几个连接

针对不同ftp使用者限制不同下载速度

操作步骤

1.安装vsftp，并启用

2.编辑: sudo vim /etc/vsftpd/vsftpd.conf

(就是对vsftpd进行配置）

可以通过命令：lftp 172.18.176.12 来查看。

如： yu@yu-laptop:/home/ftp$ lftp 172.17.184.24

lftp 172.17.184.24:~> ls (查看)

-rw-r--r-- 1 1000 1000 83643 Jul 12 10:34 023w.jpg

ftp 172.17.184.24:~> bye (退出)

use_config_dir=/etc/vsftpd/userconf

3.新增/etc/vsftpd/userconf

4./etc/vsftpd/userconf下增加test1

编辑test1

test1 local_max_rate=25000 （下载速度单位为字节 B）

5./etc/vsftpd/userconf下增加test2

编辑test2

test2 local_max_rate=30000

6.service vsftpd restart

vsftpd与Tcp_wrapper结合

1.编辑/etc/vsftpd/vsftpd.conf

tcp_wrapper=yes

2.编辑/etc/hosts.deny

vsftpd:192.168.0 10.0.0 192.168.1.3 :deny

ALL:ALL:ALLOW

3.效果 192.168.0段的和10.0.0网段 及192.168.1.3不能访问当前ftp服务器。其他地址的可以访问

将vsftpd并入xinetd 配置方法

1.编辑/etc/vsftpd/vsftpd.conf

listen=no

2.新增/etc/xinetd.d/vsftpd

service vsftpd

{

disable=no

socket_type=stream

wait=no

user=root

service=/usr/sbin/vsftpd

port=21

log_no_success+=PID HOST DURATION

log_no_failure+=HOST

}

3.service xinetd restart

vsftpd 设置用户目录

增加一个用户ftpuser并设置其目录为/opt/ftp：

1 增加组 groupadd ftpgroup

2 修改vsftpd.conf

vi /etc/vsftpd/vsftpd.conf

将底下三行

#chroot_list_enable=YES

# (default follows)

#chroot_list_file=/etc/vsftpd/chroot_list

改为

chroot_list_enable=YES

# (default follows)

chroot_list_file=/etc/vsftpd/chroot_list

3 增加用户ftpuser并设置其目录为/opt/ftp

useradd -g ftpgroup -d /opt/ftp -M ftpuser

4 设置用户口令 passwd ftpuser

5 编辑chroot_list文件:

vi /etc/vsftpd/chroot_list

内容为ftp用户名,每个用户占一行,如：

ftpuser

6 重新启动vsftpd：

/sbin/service vsftpd restart

注：可能需要设置/opt/ftp文件夹的权限：chmod 777 /opt/ftpe