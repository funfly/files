��װʹ�� PhpDocumentor

�ο���http://blog.csdn.net/hu_zhenghui/article/details/5338624

1. ��װ EasyPHP-5.3.2i-setup.exe �� D:\EasyPHP-5.3.2i
2. ���� D:\EasyPHP-5.3.2i\php\php.ini-development ������php.ini �༭ php.ini ���� date.timezone = Asia/Shanghai 
3. �༭ D:\EasyPHP-5.3.2i\php\go-pear.bat
@ECHO OFF
set PHP_BIN=%CD%/php.exe
%PHP_BIN% -d output_buffering=0 -d phar.require_hash=0 PEAR\go-pear.phar
pause
4.��װpear
    CMD->D:
    CMD->cd D:\EasyPHP-5.3.2i\php
    CMD->go-pear
    һ·�س�
5. pear install XML_Parser
6. pear install XML_Beautifier
7. pear install PhpDocumentor
8. CMD->phpdoc -h
9. CMD->D:
   CMD->cd D:\EasyPHP-5.3.2i\php
   CMD->phpdoc.bat -o HTML:Smarty:PHP -d D:\weibo\source\application\controllers\ -t D:\doc\controllers
   CMD->phpdoc.bat -o HTML:Smarty:PHP -d D:\weibo\source\application\models\ -t D:\doc\models
10. Դ����Ŀ¼��D:\weibo\source\application\controllers ע���ĵ�Ŀ¼��D:\doc\controllers

