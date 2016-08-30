#!/bin/bash
#Author: Junjie.he
#Alter:Lv.
ok(){
   [ $? == 0 ] || echo "error.check the last log."
}
Mount(){
        mkdir -p /tmp/usr/local/
        cp -r /usr/local/* /tmp/usr/local/.
        mount /dev/vdb1 /usr/local
		ok
        cp -r /tmp/usr/local/* /usr/local/.

        mkdir /game
        mount /dev/vdb2 /game
		ok
        echo "/dev/vdb1            /usr/local           ext3       defaults    0 0" >> /etc/fstab
        echo "/dev/vdb2            /game                ext3       defaults    0 0" >> /etc/fstab
exit 0
}

Init_Disk(){
        Disk=/dev/vdb
        echo -n "fdisk $Disk..."
        fdisk $Disk &>$0_fdisk.log <<EOF
n
p
1

104025
n
p
2


w
EOF
        echo "OK"
		sleep 3
        echo -n "mkfs.ext3 /dev/vdb1..."
        mkfs.ext3 /dev/vdb1 &>$0_1_mkfs.log
        ok
		echo "OK"
        echo -n "mkfs.ext3 /dev/vdb2..."
        mkfs.ext3 /dev/vdb2 &>$0_2_mkfs.log
        ok
		echo "OK"
        echo -n "mount and fstab..."
        Mount &>$0_mount.log
        echo "OK"
}
passwod(){
/etc/init.d/iptables stop
chkconfig --level 3 iptables off
killall yum-updatesd;killall yum-updatesd-helper
echo "fj6xElEFoe@7road" |passwd --stdin root 
yum --skip-broken -y install lrzsz dos2unix expect ntp curl bind-utils which syslog vim* wget curl zip unzip openssh bc mysql
cd /etc/ssh/
cp sshd_config sshd_config.bak
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' sshd_config
sed -i 's/#UseDNS yes/UseDNS no/g' sshd_config
sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 60/g' sshd_config
sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 10/g' sshd_config
sed -i 's/#Port 22/Port 16333/g' sshd_config
cd -
/etc/init.d/sshd restart 
sed  -i 's/alias cp/#alias cp/g' ~/.bashrc 
sed -i '/102400/d' /etc/profile
echo 'ulimit -n 102400' >> /etc/profile
sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 30" >>/etc/sysctl.conf 
sed -i '/net.ipv4.tcp_window_scaling/d' /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 0" >>/etc/sysctl.conf 
sed -i '/net.ipv4.tcp_sack/d' /etc/sysctl.conf
echo "net.ipv4.tcp_sack = 0" >>/etc/sysctl.conf 
/sbin/sysctl -p 
exit 0
}

main(){
        if ! [ -d /game ];then
                Init_Disk
				ok
				passwod
				ok
                rm $0 -f
        else
                echo "Error: /game exist"
                exit 1
        fi
        exit 0
}
main $*
