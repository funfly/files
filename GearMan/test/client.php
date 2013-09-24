<?php
$client= new GearmanClient();
$client->addServer('192.168.56.10', 4730);

$job_handle = $client->dobackground('test', '异步任务...');
if ($client->returnCode() != GEARMAN_SUCCESS){
    echo "bad return code:".$client->returnCode().'\n';
}else{
    echo '异步任务发布成功！\n';    
}
echo '---------------------------\n';

echo $client->do('test', '同步任务...'), "\n";
echo 'done!';

?> 