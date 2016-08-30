#!/usr/bin/env python
#coding:utf8
import re,sys,os,shutil
s_type = sys.getfilesystemencoding()
def Delet_lnk(f):
    list = os.listdir(f)
    dir = [i for i in list if os.path.isdir(os.path.join(f,i)) and not re.search('RECYCLE.BIN',i) and not re.search('System Volume Information',i)]
    if dir:
        for di in dir:
            if re.search('lck',di):
                sc = "将要删除："
                sc2 = sc.decode('utf-8').encode(s_type)
                print "%s %s" % (sc2,os.path.join(f,di))
                y_n = raw_input('yes/no: ')
                if y_n == 'yes'or y_n =='YES' :
                    shutil.rmtree(os.path.join(f,di))
            else :
                if os.path.isdir(os.path.join(f,di)):
                    Delet_lnk(os.path.join(f,di))

Delet_lnk('d:\\')
