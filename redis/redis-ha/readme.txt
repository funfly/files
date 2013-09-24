redis ha

同时请请参看 keepalived 文档


192.168.56.10   master   
192.168.56.11   slave
192.168.56.100  vip


1. 默认 vip 指向 192.168.56.10
2. 192.168.56.10 上 redis 异常；vip 自动指向 192.168.56.11；同时 192.168.56.11 上的 redis 自动设置成 master
3. 192.168.56.10 启动 redis 再启动 keepalived ；192.168.56.10 上的 redis 自动设置成 slave ；vip 继续指向 192.168.56.11；
4. 192.168.56.11 上 redis 异常；vip 自动指向 192.168.56.10；同时 192.168.56.10 上的 redis 自动设置成 master
5. 如此循环； VIP 实现平滑切换；master、slave 平实现滑切换；
6. TODO: redis 的 master、slave 切换；目前是全量同步；大数据时，表示需要改善。


参考：
   http://ylw6006.blog.51cto.com/470441/1086455
   http://wenku.baidu.com/view/511754254b73f242336c5f72.html