<?php
date_default_timezone_set('Asia/Shanghai');
$worker= new GearmanWorker();
$worker->addServer('192.168.56.10', 4730);
$worker->addFunction('test', 'my_test_function');
echo date("Y-m-d H:i:s").' working...'.chr(10).chr(32);
while ($worker->work());

function my_test_function($job) {
    sleep(5);
    file_put_contents('/usr/local/gearman/test/worker.log',date("Y-m-d H:i:s").' '.$job->workload().chr(10).chr(32),FILE_APPEND);
    return $job->workload();
}
echo date("Y-m-d H:i:s").' stop!'.chr(10).chr(32);
?>
