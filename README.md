# this is my code
name:Lvzhenqian
email:(276829290@qq.com)



这个目录用于自己写的shell与python脚本记录，方便更新与维护。

shell   是我自己写的一些shell脚本。
python  是我自己写的一些python脚本
other   是一些常用的记录
other/vimrc 与other/vim 是在github上收集，并自己改成合适自己用的vim插件


secureCRT软件不能正常的显示vim插件时，改动这文件能达到 想要到效果。

修改%appdata%\VanDyke\Config\Global.ini中的该字段为如下内容： 
B:"ANSI Color RGB"=00000040 
00 2b 38 00 dc 32 2f 00 99 ae 00 00 b5 89 00 00 26 8b d2 00 d3 36 82 00 2a a1 98 00 ee e8 d5 00 
ec b1 00 00 cb 4b 16 00 00 82 00 00 ff ff 00 00 88 88 ff 00 ff 00 ff 00 00 ff ff 00 bb bb bb 00

other/Myxshell.xcs  这是xshell所用显示vim插件的配色方案。


securecrt后，找到下面的选项，在ANSI color那里打上勾就行了，Options->Session Options->Terminal->Emulation


vim8.0编译

yum -y install ncurses-devel lua-devel python-devel perl-devel ruby-devel perl-ExtUtils-Embed

./configure --prefix=/usr/local/vim \
--enable-luainterp=yes \
--enable-pythoninterp=yes \
--enable-mzschemeinterp \
--enable-perlinterp=yes \
--enable-python3interp=yes \
--enable-tclinterp=yes \
--enable-rubyinterp=yes \
--enable-cscope \
--enable-multibyte \
--enable-hangulinput
make && make install