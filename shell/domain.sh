#!/bin/bash
#对check_file 里的$0进行了修改成$dir
#对flag①判断语句处进行了修改，减少bug
print_ok(){ #检查上一条命令的执行结果
   if [ $? -eq 0 ]
   then   
        echo -e "$1 \033[32m OK \033[0m" 
   else	
	    echo -e "$1 \033[31m Fail \033[0m"
		exit 1
   fi		
}
check_file(){	#检查文件不存在就报错退出
if [ ! -f "$1" ] 
then
   echo -e "\033[31m $1 not exit \033[0m" >> "$dir"/domain.log 
   exit 1
fi
 }
add_ng(){
    :> /tmp/test.s			#每次添加操作前都 清空下这个两个临时文件
    :> /tmp/test.assist		#这两个文件临时的放一下从区域名的截取信息
    for i in $slave			#slave这里标识从区的 sitename
    do
	   check_file "/game/"$mysite"/nginx.combine."$i"_`date +%F`"
       grep "server_name" /game/"$mysite"/nginx.combine."$i"_`date +%F`|egrep -v "#|res|assist"   >> /tmp/test.s
	   print_ok "$i /tmp/test.s"	#上面一句是将从区里 server_name 里s[0-9]+的域名信息放到这个文件里
	   grep "server_name" /game/"$mysite"/nginx.combine."$i"_`date +%F`|egrep  "assist"|grep -v "#"  >> /tmp/test.assist
	   print_ok "$i /tmp/test.assist"	#上面一句是将从区 server_name里的asist[0-9]+的域名添加到文件里
    done
###上面已经将从区域名信息截取出来，下面两句是排序后另外保存为另外两个文件
    cat /tmp/test.s |grep -v "shenquol.com"|sort -k2 > /game/"$mysite"/nginx.combine.s."$mysite"_`date +%F`
    cat /tmp/test.assist|grep -v "shenquol.com" |sort -k2  > /game/"$mysite"/nginx.combine.assist."$mysite"_`date +%F`
###flag①下面这句是判断,如果主NGINX配置文件已经添加了从的域名信息，就不再添加	
    grep -of /tmp/test.s  /usr/local/nginx-1.0.5/vhosts/nginx."$serverdir".conf  >/tmp/test.s.g
	grep -of /tmp/test.assist  /usr/local/nginx-1.0.5/vhosts/nginx."$serverdir".conf  >/tmp/test.assist.g
	[ `cat /tmp/test.s|wc -l` -eq `cat /tmp/test.s.g|wc -l` ]&& [ `cat /tmp/test.assist|wc -l` -eq `cat /tmp/test.assist.g|wc -l` ]

if [ $? -eq 0 ]
then
	    echo -e "\033[32m OK \033[0m ......slave DNS_info is already insert into the master nginx config file."
else
        check_file "/game/"$mysite"/nginx.combine.s."$mysite"_`date +%F`"
		check_file "/game/"$mysite"/nginx.combine.assist."$mysite"_`date +%F`"
        cp /usr/local/nginx-1.0.5/vhosts/nginx."$serverdir".conf{,`date +%F`}
		print_ok "back master conf"
	    line_s=`sed -n '/server_name s/=' /usr/local/nginx-1.0.5/vhosts/nginx.$serverdir.conf|tail -1`	#找到最后一行的行号插入用
        sed -i ''$line_s' r /game/'$mysite'/nginx.combine.s.'$mysite'_'`date +%F`'' /usr/local/nginx-1.0.5/vhosts/nginx."$serverdir".conf
		print_ok "insert server_name s"
		line_assist=`sed -n '/server_name assist/=' /usr/local/nginx-1.0.5/vhosts/nginx.$serverdir.conf|tail -1`
        sed -i ''$line_assist' r /game/'$mysite'/nginx.combine.assist.'$mysite'_'`date +%F`'' /usr/local/nginx-1.0.5/vhosts/nginx."$serverdir".conf
	    print_ok "insert server_name assist"
		/usr/local/nginx-1.0.5/sbin/nginx -s reload
		print_ok "nginx reload"
fi
}   

	
	
main(){
    dir=`cd $(dirname $0);pwd`
	cd $dir	
	touch domain.log
	:> domain.log
    check_file ""$dir"/config.deploy"
    mysite=`grep my_site "$dir"/config.deploy|awk -F::: '{gsub(/ /,"");print $2}'`
    slave=`grep "sites" "$dir"/config.deploy|awk -F::: '{gsub(/('$mysite'|,)/," ");print $2}'`
	serverdir=`awk -F/ '/^Path/ {print $3}' /game/"$mysite"/config.txt`
	gameName=`awk -F::: '/^joinContent:/{gsub(" ","");print $2}' "$dir"/config.deploy`
	rtxuser=`awk -F::: '/^current_task_user/{gsub(" ","");print $2}' "$dir"/config.deploy`
	create_user=`awk -F::: '/^create_task_user/{gsub(" ","");print $2}' "$dir"/config.deploy`
	
	
if [ `grep "BindDomain:::1" "$dir"/config.deploy` ]
then
    echo "-1" > "$dir"/check.deploy
    add_ng &> "$dir"/domain.log
    ###将domainBind由发送主区所有的域名改成只发送从区的域名解析
domainBind="`echo;cat /game/$mysite/nginx.combine.s.${mysite}_$(date +%F) /game/$mysite/nginx.combine.assist.${mysite}_$(date +%F)|awk '/server_name/{print $2}'|sed 's/;\|res.*//g';echo "解析到";ifconfig eth0 |awk -F[:\ ]+ '/Bcast/{print "电信"$4}';ifconfig eth0:1 |awk -F[:\ ]+ '/Bcast/{print "联通"$4}'`"
    #####添加三次发送机制。
    for (( i=0;i<=3;i++ ))
    do
    sqgame "$mysite" sendrtxmail "$rtxuser,$create_user" "神曲合区域名解析" "`echo ${gameName}"$domainBind"|sed ':label;N;s/\n/%0d/g;b label'`" 1 2>&1 >> domain.log
    wait
    [ $(tail -1 domain.log|grep -ic "OK") -eq 1 ] && break
    sleep 30
    done
    echo "0" > "$dir"/check.deploy
else
    echo "0" > "$dir"/check.deploy
fi
}
main
