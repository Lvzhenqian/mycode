#!/usr/bin/python
#_*_coding:utf-8_*_

with open('/proc/meminfo') as fd:
    for line in fd:
        if line.startswith('MemTotal'):
            total = line.split()[1]
        elif line.startswith('MemFree'):
            free = line.split()[1]
            break
b = (float(free)/int(total)) * 100
print "可用内存为：""%.2f" % b + '%'
