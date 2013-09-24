#!/usr/bin/php
<?php
echo 'pop.....'.chr(13).chr(10);
$redis = new Redis();
$redis->pconnect('192.168.56.10', 6379);
$i = 0;
while(true) {
    try {
        print_r($redis->blPop('test_list',1));
        echo chr(13).chr(10);
    } catch(Exception $e) {
        //echo $e;
    }
    $i++;
}
?>
