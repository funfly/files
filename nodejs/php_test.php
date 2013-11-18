<?php
$conn=new Mongo("mongodb://weibo:~7PnxjbS6@192.168.9.64:27017");
$db=$conn->todo_dev_php; 


$update = array('$inc' => array("inc_id" => 1));
$query = array('_id' => 'topic');
$command = array(
    'findandmodify' => 'auto_inc_ids', 
    'update' => $update,
    'query' => $query, 
    'new' => TRUE, 
    'upsert' => TRUE
);
$result = $db->command($command);
$inc_id = $result['value']['inc_id'];

            
$collection=$db->topics; 
$array = array(
    '_id'=>$inc_id,
    'uid'=>0,
    'sort'=>0,
    'unit_id'=>0,
    'group_id'=>0,
    'type'=>0,
    'category'=>0,
    'content'=>'',
    'root_tid'=>0,
    'root_uid'=>0,
    'post_time'=>0,
    'post_ip'=>'',
    'post_location'=>'',
    'from_string'=>'',
);
$result=$collection->insert($array); 
print_r($inc_id);
?>