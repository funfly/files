#!/bin/sh
redis_path=/data/smsapp
redis_dump_name=dump.rdb
redis_aof_name=appendonly.aof
backup_path=/data/smsapp/backup
backup_remote_server='root@192.168.94.22:/data/backup/'

# cp
timestamp=`date +"%Y%m%d%H%M%S"`
cp $redis_path/$redis_dump_name $backup_path/$redis_dump_name.$timestamp
cp $redis_path/$redis_aof_name $backup_path/$redis_aof_name.$timestamp
gzip $backup_path/$redis_dump_name.$timestamp
current_redis_dump_name=$redis_dump_name.$timestamp.gz
gzip $backup_path/$redis_aof_name.$timestamp
current_redis_aof_name=$redis_aof_name.$timestamp.gz
# rsync or scp
echo scp $backup_path/$current_redis_dump_name $backup_remote_server
echo scp $backup_path/$current_redis_aof_name $backup_remote_server

# clear old backups
find $backup_path -name $redis_dump_name.*.gz -mtime +7|xargs rm -f
find $backup_path -name $redis_aof_name.*.gz -mtime +7|xargs rm -f
