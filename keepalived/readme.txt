
1. ��װ������
   yum -y install gcc popt-devel openssl-devel wget make

2. ���ء���ѹ����װ ���ٷ����ص�ַ��http://www.keepalived.org/download.html��
   cd /usr/local/src
   wget http://www.keepalived.org/software/keepalived-1.2.7.tar.gz
   tar -xvf keepalived-1.2.7.tar.gz
   cd /usr/local/src/keepalived-1.2.7
   ./configure --prefix=/usr/local/keepalived
   make
   make install
   cp /usr/local/keepalived/sbin/keepalived /usr/sbin/
   cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
   cp /usr/local/keepalived/etc/rc.d/init.d/keepalived /etc/init.d/


3. ���� keepalived��Ĭ�������keepalived����ʱ��ȥ/etc/keepalivedĿ¼���������ļ���
   mkdir /etc/keepalived
   �� conf-10/keepalived.conf �ϴ���IPΪ��192.168.56.10 ��  /etc/keepalived
   �� conf-11/keepalived.conf �ϴ���IPΪ��192.168.56.11 ��  /etc/keepalived
   
4. ���� keepalived
   /usr/local/keepalived/sbin/keepalived -D
   ps -aux | grep keepalived

5. ��֤ keepalived ������IP
   ������������ping VIP������pingͨ����ip
   ping 192.168.56.100

6. ���� keepalived �Ľ����������Ƿ��ܴ�����ؽű���VIP�Ƿ��Զ��л�
   mkdir /home/tool
   �ϴ� pkill_keepalived.sh �� /home/tool
   chmod +x /home/tool/pkill_keepalived.sh
   
   ʵ�ֲ��裺
       1. ������1 : 192.168.56.10  VIP:192.168.56.100   ����ʱ�ر�iptables��
       2. ������2 : 192.168.56.11  VIP:192.168.56.100   ����ʱ�ر�iptables��
       3. ������3 : 192.168.56.12  VIP:192.168.56.100   ����ʱ�ر�iptables��
       4. ����ɢ����������nginx�������ʣ�
          http://192.168.56.10/index.php �÷�������ǰ��ҳ���ݣ�10...
          http://192.168.56.11/index.php �÷�������ǰ��ҳ���ݣ�11...
          http://192.168.56.12/index.php �÷�������ǰ��ҳ���ݣ�12...
       5. ��������������������keepalived��/usr/local/keepalived/sbin/keepalived -D
       6. �ֱ�鿴��������������־��tail -f /var/log/messages
       7. ͨ������IP��������ҳ��http://192.168.56.100/index.php ��ǰ����Ӧ���ǣ�10...
       8. ֹͣ 192.168.56.10 �ϵ� nginx ���񣬲��۲���������������־���磺/etc/init.d/mysqld stop ��ʱ��VIPָ��192.168.56.11������
       9. �ٴ�ͨ������IP��������ҳ��http://192.168.56.100/index.php ��ǰ����Ӧ���ǣ�11...
       10.���Լ���ֹͣ 192.168.56.11 �ϵ� nginx ������VIPָ��192.168.56.12������������ http://192.168.56.100/index.php ����Ӧ���ǣ�12...
       
7. �ر� keepalived
   pkill keepalived

8. �鿴��־
   tail -f /var/log/messages

�ο���
   http://kb.cnblogs.com/page/83944/
   