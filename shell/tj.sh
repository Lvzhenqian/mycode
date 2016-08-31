#!/bin/bash
##ps sum
#BY Lv.
sum=0
for i in `ps aux |awk -F" " '$6~/[0-9]/ {print $6}'`
do
   sum=$[$sum+$i]
   n=$[sum/1000]
done
echo "$n M"
