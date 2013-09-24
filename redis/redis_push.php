
入队列操作：<br><br>

<?php
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
$i = 0;
while ($i < 10) {
    $n = rand(1000,9999);
    echo $i.':'.$n.'<br>';
    $redis->lPush('test_list', 'A_'.$n);
    $i++;
}
echo '完成';
?>

