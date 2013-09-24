#! /usr/local/webserver/mybak/bin/php -d safe_mode = Off

<?php

require('utils.php');
$argv =& $_SERVER['argv'];

function printUsage() {
	global $argv;
	$bin = $argv[0];
	$usage = "Usage: $bin <configName> <targetDate>. \n"
	    . "\t<configName>: name of the mysql config in config.php.\n"
	    . '\t<targetDate>: the date to restore to, date format: YYYYMMDD';
    nPrint($usage);
}

if (count($argv) <= 1) {
    printUsage();
    exit(100);
}

if ($argv[1] == '-h' || $argv[1] == '--help') {
	printUsage(0);
	exit(0);
}

$name = $argv[1];
$date = count($argv) > 2 ? $argv[2] : date('Ymd');
$success = restoreBackup($name, $date);

exit($success ? 0 : 1);

?>
