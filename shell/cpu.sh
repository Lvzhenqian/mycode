#!/bin/bash
while :
do
    name=$(awk '$1~/cpu$/{print $1}' /proc/stat)
    user1=$(awk '$1~/cpu$/{print $2}' /proc/stat)
    nice1=$(awk '$1~/cpu$/{print $3}' /proc/stat)
    system1=$(awk '$1~/cpu$/{print $4}' /proc/stat)
    total1=$(awk '$1~/cpu$/ {sum=($1+$2+$3+$4+$5+$6+$7+$8+$9);print sum}' /proc/stat)
    sleep 1
    user2=$(awk '$1~/cpu$/{print $2}' /proc/stat)
    nice2=$(awk '$1~/cpu$/{print $3}' /proc/stat)
    system2=$(awk '$1~/cpu$/{print $4}' /proc/stat)
    total2=$(awk '$1~/cpu$/ {sum=($1+$2+$3+$4+$5+$6+$7+$8+$9);print sum}' /proc/stat)
    user0=$((user2-user1))
    nice0=$((nice2-nice1))
    system0=$((system2-system1))
    zy=$[$((user0+nice0+system0))/$((total2-total1)) * 100]
    clear
    printf "%-8s %-8s %-8s %-8s\n" $name user "nice" system
    printf "%-8s %-8s %-8s %-8s\n" $zy%  $user0 $nice0 $system0
    read -t 1 key
    [ "$key" == "q" -o "$key" == "Q" ] && exit 0
done
