��װʹ�� phpunit

1. ��װ EasyPHP-5.3.2i-setup.exe �� D:\EasyPHP-5.3.2i
2. ���� D:\EasyPHP-5.3.2i\php\php.ini-development ������php.ini �༭ php.ini ���� date.timezone = Asia/Shanghai 
3. �༭ D:\EasyPHP-5.3.2i\php\go-pear.bat
@ECHO OFF
set PHP_BIN=%CD%/php.exe
%PHP_BIN% -d output_buffering=0 -d phar.require_hash=0 PEAR\go-pear.phar
pause
4. ��װpear
   CMD->D:
   CMD->cd D:\EasyPHP-5.3.2i\php
   CMD->go-pear
   һ·�س�
   CMD->pear -V
   CMD->pear list
   CMD->pear install Image_GraphViz
   CMD->pear install Log
   CMD->pear channel-discover components.ez.no
   CMD->pear channel-discover pear.phpunit.de
   CMD->pear channel-discover pear.symfony-project.com
   CMD->pear upgrade-all 
   CMD->pear clear-cache
   CMD->pear install --alldeps --force phpunit/PHPUnit
   CMD->phpunit -version

5. ����PHP��չ D:\EasyPHP-5.3.2i\php\php.ini
   ; extension_dir = "ext" �ĳ� extension_dir = "ext"
   ;extension=php_curl.dll �ĳ� extension=php_curl.dll
   ;extension=php_mysql.dll �ĳ� extension=php_mysql.dll
   ���Ը�����Ҫ��������PHP��չ
   
6. ���ԣ�
   CMD->D:
   CMD->cd D:\weibo\source\weibo_case
   CMD->D:\EasyPHP-5.3.2i\php\phpunit TopicTest.php
   
�ο���
   http://hi.baidu.com/zjutxujie/item/7b08761f922df7476926bb2c
   http://blog.lixiphp.com/windows-install-pear-phpunit/#axzz2c1dylngM
   http://hi.baidu.com/wuhui/item/17986ed5d9a90893260ae729
