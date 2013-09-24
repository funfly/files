#! /usr/local/webserver/mybak/bin/php -d safe_mode = Off

<?php

require('utils.php');

$dbs =& getDbConfigs();
foreach ($dbs as $name => $config) {
    deltaBackup($name, $config);
}

?>
