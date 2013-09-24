#!/bin/sh
backup_path=/data/smsapp/backup
redis_dump_name=dump.rdb
backup_redis_daily_script=`dirname $0`/backup_redis.sh
history_path=/data/smsapp/history
backup_remote_server='root@192.168.94.22:/data/history/'

# find most recent backup file
current_date=`date +"%Y%m%d"`
current_file=""
for f in `ls -lr $backup_path/$redis_dump_name.$current_date*.gz 2>/dev/null`; do
  current_file=$f
done
#echo "1 current_file=$current_file"
if [ -z $current_file ]
then
  echo `$backup_redis_daily_script`
  for f in `ls -lr $backup_path/$redis_dump_name.$current_date*.gz 2>/dev/null`; do
    current_file=$f
  done
fi
#echo "2 current_file=$current_file"
# check
if [ ! -f $current_file ]
then
  echo "error exit"
  exit
fi

# cp
cp $current_file $history_path/
#echo "3 after cp"
echo scp $current_file $backup_remote_server
