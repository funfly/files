#! /usr/local/webserver/mybak/bin/php -d safe_mode = Off

<?php

require('utils.php');

$dbs =& getDbConfigs();
foreach ($dbs as $name => $config) {
    listBackup($name, $config);
}

?>
