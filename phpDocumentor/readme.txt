安装使用 PhpDocumentor

参考：http://blog.csdn.net/hu_zhenghui/article/details/5338624

1. 安装 EasyPHP-5.3.2i-setup.exe 到 D:\EasyPHP-5.3.2i
2. 复制 D:\EasyPHP-5.3.2i\php\php.ini-development 改名：php.ini 编辑 php.ini 设置 date.timezone = Asia/Shanghai 
3. 编辑 D:\EasyPHP-5.3.2i\php\go-pear.bat
@ECHO OFF
set PHP_BIN=%CD%/php.exe
%PHP_BIN% -d output_buffering=0 -d phar.require_hash=0 PEAR\go-pear.phar
pause
4.安装pear
    CMD->D:
    CMD->cd D:\EasyPHP-5.3.2i\php
    CMD->go-pear
    一路回车
5. pear install XML_Parser
6. pear install XML_Beautifier
7. pear install PhpDocumentor
8. CMD->phpdoc -h
9. CMD->D:
   CMD->cd D:\EasyPHP-5.3.2i\php
   CMD->phpdoc.bat -o HTML:Smarty:PHP -d D:\weibo\source\application\controllers\ -t D:\doc\controllers
   CMD->phpdoc.bat -o HTML:Smarty:PHP -d D:\weibo\source\application\models\ -t D:\doc\models
10. 源代码目录：D:\weibo\source\application\controllers 注释文档目录：D:\doc\controllers

