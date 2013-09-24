安装使用 phpunit

1. 安装 EasyPHP-5.3.2i-setup.exe 到 D:\EasyPHP-5.3.2i
2. 复制 D:\EasyPHP-5.3.2i\php\php.ini-development 改名：php.ini 编辑 php.ini 设置 date.timezone = Asia/Shanghai 
3. 编辑 D:\EasyPHP-5.3.2i\php\go-pear.bat
@ECHO OFF
set PHP_BIN=%CD%/php.exe
%PHP_BIN% -d output_buffering=0 -d phar.require_hash=0 PEAR\go-pear.phar
pause
4. 安装pear
   CMD->D:
   CMD->cd D:\EasyPHP-5.3.2i\php
   CMD->go-pear
   一路回车
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

5. 开启PHP扩展 D:\EasyPHP-5.3.2i\php\php.ini
   ; extension_dir = "ext" 改成 extension_dir = "ext"
   ;extension=php_curl.dll 改成 extension=php_curl.dll
   ;extension=php_mysql.dll 改成 extension=php_mysql.dll
   可以根据需要开启其他PHP扩展
   
6. 测试：
   CMD->D:
   CMD->cd D:\weibo\source\weibo_case
   CMD->D:\EasyPHP-5.3.2i\php\phpunit TopicTest.php
   
参考：
   http://hi.baidu.com/zjutxujie/item/7b08761f922df7476926bb2c
   http://blog.lixiphp.com/windows-install-pear-phpunit/#axzz2c1dylngM
   http://hi.baidu.com/wuhui/item/17986ed5d9a90893260ae729
