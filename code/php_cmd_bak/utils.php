<?php

$config = include('config.php');
$eol = $config['eol'];
$isDebug = $config['debug'];

$COMMANDS = array(
    'cp'     => '/bin/cp',
    'mv'     => '/bin/mv',
    'rm'     => '/bin/rm',
    'mkdir'  => '/bin/mkdir',
    'chown'  => '/bin/chown',
    'tar'    => '/bin/tar',
    'gzip'   => '/bin/gzip',
    'gunzip' => '/bin/gunzip',
    'innobackupex' => '/usr/bin/innobackupex',
);

function nPrint($msg = null) {
    global $eol;
    echo $msg, $eol;
}

function tPrint($msg = null) {
    nPrint(date('c') . ' ' . $msg);
}

function iPrint($msg) {
    tPrint("[INFO] $msg");
}

function ePrint($msg) {
    tPrint("[ERROR] $msg");
}

function wPrint($msg) {
    tPrint("[WARN] $msg");
}

function dPrint($msg) {
    global $isDebug;

    if (!$isDebug) {
        return;
    }

    tPrint("[DEBUG] $msg");
}

function execCmd($cmd) {
    $rc = 0;
    passthru($cmd, $rc);
    return $rc;
}

function getCmdOut($cmd) {
    return system($cmd);
}

function &getDbConfigs() {
    global $config;
    $configs =& $config['dbs'];
    return $configs;
}

function &getDbConfig($name) {
    $configs =& getDbConfigs();
    if (!array_key_exists($name, $configs)) {
        wPrint("Database config $name not exists");
        return null;	
    }
    
    $config =& $configs[$name];
    return $config;
}

function runCmd($cmd, $fullpath = false) {
	$command = $cmd;
	if (!$fullpath) { 
	    global $COMMANDS;
	    $fields = explode(' ', $cmd);
	    $cmd = $fields[0];
	    if (array_key_exists($cmd, $COMMANDS)) {
	        $fields[0] = $COMMANDS[$cmd];
	    } else {
	        wPrint("No full path for $cmd");
	    }
	    $command = implode(' ', $fields);
	}

    iPrint("Running command: $command");
    return execCmd($command);
}

function runCmdAtFolder($cmd, $folder) {
	$pwd = getcwd();
	iPrint("Change working direcotry to $folder");
	chdir($folder);
	runCmd($cmd);
	chdir($pwd);
}

function trimpath($folder) {
    $len = strlen($folder);
    if ($len <= 0) {
    	return null;
    }
    
    $lastChar = $folder[$len - 1];
    if ($lastChar == '/' || $lastChar == '\\') {
	    $folder = substr($folder, 0, -1);
    }
    
    return $folder;
}


function isArchive($file) {
	return is_file($file) && strpos($file, '.tar.gz') !== false;
}

function archive($path) {
	if (!file_exists($path)) {
		ePrint("$path not exist");
		return null;
	}
	
	$folder = dirname($path);
	$file = basename($path);
	
	$tar = "$file.tar";
	$zip = "$file.tar.gz";
	iPrint("Archive $file as $zip");
	
	$cmd = "tar -cf $tar $file";
	$rc1 = runCmdAtFolder($cmd, $folder);
	$cmd = "gzip -f $folder" . DIRECTORY_SEPARATOR . $tar;
	$rc2 = runCmd($cmd);
	if ($rc1 != 0 || $rc2 != 0) {
		ePrint("Failed to archive $file");
		$cmd = "rm -f $tar";
		runCmd($cmd);
		return null;
	}
	
	$cmd = "rm -rf $path";
	runCmd($cmd);
	
	return $zip;
}

function extractBackup($archive, $targetFolder) {
	if (strpos($archive, '.tar') === false || 
	    strpos($archive, '.gz') === false) {
	   ePrint("Cannot decompress archive $archive"); 
	   return null;	
	}
	
	$backup = substr(basename($archive), 0, -7);
	iPrint("Extract $backup from $archive");
	
	$backupPath = $targetFolder . DIRECTORY_SEPARATOR . $backup;
	$archiveBak = "$backupPath.bak.tar.gz";
	if (file_exists($archiveBak)) {
		$time = time();
		$cmd = "mv $archiveBak $backupPath.bak.$time.tar.gz";
		runCmd($cmd);
	}
	
	
	$cmd = "cp $archive $archiveBak";
	runCmd($cmd);
	
	$cmd = "gunzip -f $archiveBak";
	runCmd($cmd);
	
	$tar = "$backup.bak.tar";
	$cmd = "tar -xf $tar";
	$rc = runCmdAtFolder($cmd, $targetFolder);
	
	$cmd = "rm -f $backupPath.bak.tar";
	runCmd($cmd);
	
	if ($rc != 0) {
		ePrint("Failed to extract $backup from $archive");
		return null;
	}
	
	return $backupPath;
}

function archiveBackups($home) {
	iPrint("Create backup archives in $home");
	
	$date = date('Ymd');
    $files = scandir($home, 1);
    foreach ($files as $file) {
    	if ($file == '.' || $file == '..') {
    		continue;
    	}
    	
    	if (strpos($file, '.bak') !== false) {
    	    continue;	
    	}
    	
    	// Skip archive the bacukp created this date
    	if (strpos($file, $date) !== false) {
    		continue;
    	}

    	$path = $home . DIRECTORY_SEPARATOR . $file;
        if (!isArchive($path)) {
        	archive($path);
        }
    }
}

function createBackupFolder($home, $type) {
    if (!file_exists($home)) {
        wPrint("Folder $home not found, create folder $home");
        $cmd = "mkdir -p $home";
        runCmd($cmd);
    }

    $date = date('Ymd');
    $folder = $home . DIRECTORY_SEPARATOR . $date . '.' . $type;
    if (file_exists($folder)) {
        $time = time();
        $backup = "$folder.$time.bak";
        wPrint("Folder $folder found, backup it as $backup");

        $cmd = "mv $folder $backup";
        runCmd($cmd);
    }

    return $folder;
}

function getLastBackupFolder($home) {
    $files = scandir($home, 1);
    foreach ($files as $file) {
    	if ($file == '.' || $file == '..') {
    		continue;
    	}
    	
    	if (strpos($file, '.bak') !== false) {
    	    continue;	
    	}
    	   	    	
        return $home . DIRECTORY_SEPARATOR . $file;
    }

    return null;
}

function getBaseBackupFolder($home, $date) {
	$lastBackup = "$date.base.tar.gz";
    $files = scandir($home, 1);
    foreach ($files as $file) {
    	if ($file == '.' || $file == '..') {
    		continue;
    	}
    	
    	if (strpos($file, '.bak') !== false) {
    	    continue;	
    	}
    	 	
    	if (strpos($file, '.base') === false) {
    		continue;
    	}
    	
    	if (strcmp($file, $lastBackup) <= 0) {
        	return $home . DIRECTORY_SEPARATOR . $file;
        }
    }

    wPrint("Cannot find base backup to restore to $date");
    return null;
}

function &getDeltaBackups($home, $minDate, $maxDate) {
	$backups = array();
	$minBackup = "$minDate.delta";
	$maxBackup = "$maxDate.delta.tar.gz";
    $files = scandir($home);
    foreach ($files as $file) {
    	if ($file == '.' || $file == '..') {
    		continue;
    	}
    	
    	if (strpos($file, '.bak') !== false) {
    	    continue;	
    	}
    	
    	if (strpos($file, '.delta') === false) {
    		continue;
    	}
    	    	
        $path = $home . DIRECTORY_SEPARATOR . $file;
        if (strcmp($file, $minBackup) >= 0 && strcmp($file, $maxBackup) <= 0) {
        	$backups[] = $path;
        }
    }

    if (count($backups) <= 0) {
    	wPrint("Cannot find delta backup to restore to $maxDate");
    }
    
    return $backups;
}

function fullBackup($name, $config) {
    $home = $config['backupFolder'] . DIRECTORY_SEPARATOR . $name ;
    $backupFolder = createBackupFolder($home, 'base');
    $cmd = 'innobackupex --defaults-file=' . $config['config']
        . ' --socket=' . $config['socket']
        . ' --user=' . $config['username']
        . ' --password=' . $config['password']
        . " $backupFolder --no-timestamp";
    iPrint("Create full backup for $name to folder $backupFolder");
    $rc = runCmd($cmd);
    if ($rc != 0) {
    	ePrint("Failed to create full backup for $name");
    	$cmd = "rm -rf $backupFolder";
    	runCmd($cmd);
    }
    
    return $rc == 0;
}

function deltaBackup($name, $config) {
    $home = $config['backupFolder'] . DIRECTORY_SEPARATOR . $name ;
    $backupFolder = createBackupFolder($home, 'delta');
    $baseBackup = getLastBackupFolder($home);
    $baseArchiveExists = isArchive($baseBackup);
    if ($baseArchiveExists) {
    	$baseBackup = extractBackup($baseBackup, dirname($baseBackup));
    	if (is_null($baseBackup)) {
    		return false;
    	}
    }
    if (!file_exists($baseBackup)) {
        ePrint("Base backup folder not found");
        return false;
    }

    $cmd = 'innobackupex --defaults-file=' . $config['config']
        . ' --socket=' . $config['socket']
        . ' --user=' . $config['username']
        . ' --password=' . $config['password']
        . " --incremental $backupFolder"
        . " --incremental-basedir=$baseBackup --no-timestamp";
    iPrint("Create delta backup for $name to folder $backupFolder, "
       . "base backup is $baseBackup");
    $rc = runCmd($cmd);
    
    if ($baseArchiveExists) {
        $cmd = "rm -rf $baseBackup";
        runCmd($cmd);
    }
    
    if ($rc != 0) {
    	ePrint("Failed to create delta backup for $name");
    	$cmd = "rm -rf $backupFolder";
    	runCmd($cmd);
    }
    
    archiveBackups($home);
    return $rc == 0;
}

function getMySqlConfig($config, $section, $key) {
	$config = parse_ini_file($config, true);
	if (is_null($config)) {
		return null;
	}
	
	if (!array_key_exists($section, $config)) {
		return null;
	}
	
	$sectionConfig = $config[$section];
	if (!array_key_exists($key, $sectionConfig)) {
		return null;
	}

	return $sectionConfig[$key];
}

function getBackupList($name, $config) {
	$home = $config['backupFolder'] . DIRECTORY_SEPARATOR . $name;
	if (!file_exists($home)) {
		return null;
	}
	
	$backups = array();
    $files = scandir($home, 1);
    foreach ($files as $file) {
    	if ($file == '.' || $file == '..') {
    		continue;
    	}
    	
    	if (strpos($file, '.bak') !== false) {
    	    continue;	
    	}

    	$fields = explode('.', $file);
    	$backup = array(
    	    'date' => $fields[0],
    	    'type' => $fields[1],
    	    'file' => $file,
    	);
        $backups[] = $backup;
    }
    
    return $backups;
}

function listBackup($name, $config) {
	iPrint("List backups for mysql $name");
	
	$backups = getBackupList($name, $config);
	if (count($backups) <= 0) {
    	wPrint("Cannot find any backup for mysql $name");
    	return;
    }
    
	foreach ($backups as $backup) {
		$date = $backup['date'];
		$file = $backup['file'];
		$type = $backup['type'];
		$info = "date: $date, type: $type, file: $file";
		nPrint($info);
	}
}

function restoreBackup($name, $date) {
	$config = getDbConfig($name);
	$home = $config['backupFolder'] . DIRECTORY_SEPARATOR . $name;
	$baseBackup = getBaseBackupFolder($home, $date);
	
	$restoreBackup = $baseBackup;
    $baseArchiveExists = isArchive($baseBackup);
    if ($baseArchiveExists) {
    	$restoreBackup = extractBackup($baseBackup, dirname($baseBackup));
    	if (is_null($restoreBackup)) {
    		return false;
    	}
    }
    
    if (!file_exists($restoreBackup)) {
		ePrint("Base backup $restoreBackup not found");
		return false;
	}
	
	$fields = explode('.', $baseBackup);
	$baseDate = basename($fields[0]);
	$deltaBackups = null;
	if ($baseDate != "$date.base") {
		$deltaBackups =& getDeltaBackups($home, $baseDate, $date);
	}
	
	$lastDeltaBackup = is_null($deltaBackups) ? null : end($deltaBackups);
	$fields = explode('.', $lastDeltaBackup);
	$lastDate = basename($fields[0]);
	if ($baseDate != $date && $lastDate != $date) {
		ePrint("No enough backup to restore to $date");
		return false;
	}
	
	iPrint("Restore with base backup $baseBackup");
 
	$success = false;
	try {
		iPrint("Apply redo log to base backup $restoreBackup");
		$cmd = "innobackupex --apply-log --redo-only $restoreBackup";
		$rc = runCmd($cmd);
	    if ($rc != 0) {
	    	ePrint("Failed to apply redo log to base backup $restoreBackup");
	    	goto cleanup;
	    }
		
		foreach ($deltaBackups as $deltaBackup) {
			$deltaBackupFolder = $deltaBackup;
			if (isArchive($deltaBackup)) {
				$deltaBackupFolder = extractBackup($deltaBackup, dirname($deltaBackup));
				if (is_null($deltaBackupFolder)) {
				    goto cleanup;	
				}
			}
			
			iPrint("Merge delta backup $deltaBackupFolder to base backup $restoreBackup");
			$cmd = "innobackupex --apply-log --redo-only $restoreBackup " 
			    . "--incremental-dir=$deltaBackupFolder";
			$rc = runCmd($cmd);
			
			if ($deltaBackupFolder != $deltaBackup) {
				$cmd = "rm -rf $deltaBackupFolder";
				runCmd($cmd);
			}
			
			if ($rc != 0) {
		    	ePrint("Failed to merge delta backup $deltaBackupFolder to base backup $restoreBackup");
		    	goto cleanup;
		    }
		}

		iPrint("Apply undo log to base backup $restoreBackup"); 
		$cmd = "innobackupex --apply-log $restoreBackup";			
		$rc = runCmd($cmd);
		if ($rc != 0) {
	    	ePrint("Failed to apply undo log to base backup $restoreBackup");
	    	goto cleanup;
	    }
				
		iPrint("Stop mysql $name");
		$cmd = $config['mysqlStopCmd'];
		$rc = runCmd($cmd, true);
		if ($rc != 0) {
	    	ePrint("Failed to stop mysql $name");
	    	goto cleanup;
	    }		
		
		$time = time();
		$mysqlConfig = $config['config'];
		$dataFolder = trimpath(getMySqlConfig($mysqlConfig, 'mysqld', 'datadir'));
		$dataBackup = "$dataFolder.$time.bak";
		iPrint("Backup msyql datadir $dataFolder to $dataBackup");
		$cmd = "mv $dataFolder $dataBackup";
		runCmd($cmd);
	
		iPrint("Restore data from $restoreBackup to $dataFolder");
		$cmd = "mkdir -p $dataFolder";
		runCmd($cmd);
		$cmd = "innobackupex --defaults-file=$mysqlConfig --copy-back $restoreBackup";
		$rcRestore = runCmd($cmd);
		if ($rcRestore != 0) {
	    	ePrint("Failed to restore data from $restoreBackup to $dataFolder, " 
	    	    . "restore msyql datadir from $dataBackup to $dataFolder");
			$cmd = "mv $dataBackup $dataFolder";
			runCmd($cmd);	    	
	    }
	    
		$cmd = "chown -R mysql:mysql $dataFolder";
		runCmd($cmd);
		iPrint("Start mysql $name");
		$cmd = $config['mysqlStartCmd'];
		$rc = runCmd($cmd, true);
		if ($rc != 0) {
	    	ePrint("Failed to start mysql $name");
	    	goto cleanup;
	    }
		
		$success = ($rcRestore == 0);
	} catch (Exception $e) {
		throw $e;
	}

cleanup:
    if ($restoreBackup != $baseBackup) {
	    $cmd = "rm -rf $restoreBackup";
	    runCmd($cmd);
    }
	return $success;
}

?>
