<?php

return array(
    'eol' => "\n",
    'debug' => true,
    'dbs' => array(
        '3306' => array(
            'config'   => '/mysql/3306/my.cnf',
            'username' => 'root',
            'password' => 'abcd1234',
            'socket'   => '/tmp/mysql.sock',
            'backupFolder' => '/back/mysql', 
            'mysqlStartCmd' => '/sbin/service mysql start', 
            'mysqlStopCmd' => '/sbin/service mysql stop', 
        ),
    ),  
);

?>

