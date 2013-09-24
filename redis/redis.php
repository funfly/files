
<?php

$redis = new Redis();
$redis->connect('127.0.0.1', 6379);

$redis->set('key', 'value');

echo $redis->get('key')."\n";

$redis->setex('key', 3600, 'value'); // sets key → value, with 1h TTL.

$redis->set('key1', 'val1');
$redis->set('key2', 'val2');
$redis->set('key3', 'val3');
$redis->set('key4', 'val4');

$redis->delete('key1', 'key2');
echo 'key3='.$redis->get('key3')."<br>" ;

$redis->delete(array('key3', 'key4'));
echo 'key3='.$redis->get('key3')."<br>" ;

exit;
?>

<hr>
入队列操作：<br><br>

<?php
$redis = new Redis();
$redis->connect('127.0.0.1', 6379);
while (true) {
    $redis->lPush('list1', 'A_'.date('Y-m-d H:i:s'));
    sleep(rand()%3);
}
?>

<hr>
出队列操作：<br><br>

<?php
$redis = new Redis();
$redis->pconnect('127.0.0.1', 6379);
while(true) {
    try {
        var_export( $redis->blPop('list1', 10) );
    } catch(Exception $e) {
        //echo $e;
    }
}
?>
