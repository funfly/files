#!/usr/bin/php
<?php
$redis = new Redis();
$redis->connect('192.168.56.10', 6379);
$i = 0;
while ($i < 10) {
    $n = date("Y-m-d H:i:s_").rand(1000,9999);
    echo $i.':'.$n.chr(13).chr(10);
    $redis->lPush('test_list', 'A_'.$n);
    $i++;
}
echo 'done!';
?>

