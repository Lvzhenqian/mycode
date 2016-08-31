date=`date -d "-1 day" +%F`
if [ -f /root/backup/iptables_bak.ipt ]
then
  /bin/mv /root/backup/iptables_bak.ipt /root/backup/ipt/$date.ipt
fi
/sbin/iptables-save > /root/backup/iptables_bak.ipt
sc=`date -d "-7 day" +%F`
if [ -f /root/backup/ipt/$sc.ipt ]
then
   rm -rf /root/backup/ipt/$sc.ipt
fi
