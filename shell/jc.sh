#!/bin/bash
####this script for processlist
##by lv
ps aux|awk '{print $11,$6}'|sort -t" " -k2rn|egrep "nginx|zabbix|mysqld|php"> /tmp/nc.tmp
