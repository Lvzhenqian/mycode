#!/bin/bash
##This is A Backup Script
##by lv.


##Backup
date=`date -d "-1 day" +%F`
backup_dir=/root/mysql_bak
[ -d $backup_dir ] || mkdir $backup_dir
/usr/local/mysql/bin/mysqldump -uroot --default-character-set=utf8 -p'angelo_5566!@' lives90 > /root/mysql_backup
if [ $? == 0 ]
then
  /bin/mv /root/mysql_backup $backup_dir/$date-mysql.sql
fi

##clean older backup
old_date=`date -d "-20 day" +%F`
cd $backup_dir
if [ -f $old_date-mysql.sql ]
then
  rm -rf $old_date-mysql.sql
fi
