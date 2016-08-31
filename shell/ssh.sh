#!/bin/bash
###this script for ssh port
##by Lv.
port=`/bin/netstat -lnp|grep ssh|awk -F" " '{print $4}'|awk -F":" '$1~/0.0.0.0/ {print $2}'`
ssh_stat=`/sbin/iptables -nL --line-num|grep "$port"|awk -F" " '{print $2}'`
ip_num=`/sbin/iptables -nL --line-num|grep "$port"|awk -F" " '{print $1}'`
ip_stat=`/sbin/iptables -nL|awk -F'[ )]' '$2~/INPUT/ {print $4}'`
#### input chain
input(){
if [ $ip_stat == DROP ]
then
   /sbin/iptables -I INPUT -p tcp --dport $port -j ACCEPT
fi
}
#### for DROP chain
drop(){
if [ $ssh_stat == DROP ]
then
   /sbin/iptables -D INPUT $ip_num
fi
}
if [ -z $ssh_stat ] && [ -z $ip_num ]
then
   input
else
  drop
fi
