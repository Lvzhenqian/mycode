#!/bin/bash
sum=0
for i in `ls /proc |grep "^[0-9]"|awk '$0 >100'`
do
   name=`ps -p $i -o comm --no-headers`
   for swap in `grep Swap /proc/$i/smaps 2>/dev/null|awk '{print $2}'`
   do
     sum=$[sum+swap]
   done
   sum=$[sum/1000]
   echo "$i $name $sum M"
done
