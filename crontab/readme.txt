[安装crontab]

yum -y install vixie-cron crontabs
service crond start   #启动服务
service crond stop    #关闭服务
service crond restart #重启服务
service crond reload  #重新载入配置

[编辑]
crontab -e
service crond restart #重启服务

[查看]
crontab -l

