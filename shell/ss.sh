sum=0
for i in `ps aux|awk '{print $11,$6}'|sort -t" " -k2rn|egrep "$1"|awk '{print $2}'`
do
    sum=$[i + sum]
done
echo  "$[sum / 1024] M"
