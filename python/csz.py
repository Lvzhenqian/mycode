#_*_ coding:utf-8 _*_
import random
for i in xrange(1,7):
    wj = input('please input number: ')
    st = random.randint(1, 20)
    if wj == st:
        print "%s等于%s" % (wj,st)
        print '猜对了，你赢了'
        break
    elif wj > st:
        print "%s大于%s，猜大了" % (wj,st)
    elif wj < st:
        print "%s小于%s，猜小了" % (wj,st)
else:
    print '次数够了，你输了'