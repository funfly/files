<?php
$filename = "/usr/include/stdio.h";             //所上传的文件
$fdfs = new FastDFS();                           //调用FastDFS类
$file_info = $fdfs->storage_upload_by_filename($filename,html);         //上传文件 $filename 是所上传的文件，html是上传后的更名后缀名为.html

echo '点击查看刚刚上传的文件内容：<a href="'.$file_info['filename'].'" target="_blank">'.$file_info['filename'].'</a>';

echo '<pre>';
print_r($file_info);
//echo $file_info['filename'];                       //输出上传文件目录和文件名
?>
