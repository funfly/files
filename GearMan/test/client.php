<?php
$client= new GearmanClient();
$client->addServer('192.168.56.10', 4730);

$job_handle = $client->dobackground('test', '�첽����...');
if ($client->returnCode() != GEARMAN_SUCCESS){
    echo "bad return code:".$client->returnCode().'\n';
}else{
    echo '�첽���񷢲��ɹ���\n';    
}
echo '---------------------------\n';

echo $client->do('test', 'ͬ������...'), "\n";
echo 'done!';

?> 