
出队列操作：<br><br>

<?php
echo '<pre>';
$redis = new Redis();
$redis->pconnect('127.0.0.1', 6379);
$i = 0;
while($i < 10) {
    try {
        print_r($redis->blPop('test_list',1));
        echo '<br>';
    } catch(Exception $e) {
        //echo $e;
    }
    $i++;
}
?>
