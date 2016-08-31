#!/bin/bash
###web backup script
#by lv.

###web file
rsync -av /web/www /root/web_bak


#### backup nginx
/usr/bin/rsync -av /usr/local/nginx /root/web_bak/nginx/file
/bin/cp -f /usr/local/nginx/conf/nginx.conf /root/web_bak/nginx/conf
/bin/cp -f /etc/init.d/nginx /root/web_bak/nginx/init


###php backup
/usr/bin/rsync -av /usr/local/php /root/web_bak/php/file
/usr/bin/rsync -av /usr/local/php/etc /root/web_bak/php/conf
/bin/cp -f /etc/init.d/php-fpm /root/web_bak/php/init
