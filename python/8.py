#!/usr/bin/env python
import sys,os
from optparse import OptionParser

def opt():
    parser = OptionParser()
    parser.add_option("-c", "--char",
		      dest="chars",
		      action="store_true",
		      default=False,
		      help="only count chars")
    parser.add_option("-w", "--word",
		      dest="words",
		      action="store_true",
		      default=False,
		      help="only count words")

    parser.add_option("-l", "--line",
		      dest="lines",
		      action="store_true",
		      default=False,
		      help="only count lines")
    parser.add_option("-n", "--no-total",
		      dest="total",
		      action="store_true",
		      default=False,
		      help="close the total")


    option,args = parser.parse_args()
    return option,args




def get_count(data):
    chars = len(data)
    words = len(data.split())
    lines = data.count('\n')
    return lines,words,chars

def print_wc(option,lines,words,chars,fn):
    if option.lines:
	print lines,
    if option.words:
	print words,
    if option.chars:
	print chars,
    print fn

def main():
    option,args = opt()
    if not (option.lines or option.words or option.chars):
	option.lines, option.words, option.chars = True, True, True
    if args:
        total_lines,total_words,total_chars = 0,0,0
        for fn in args:
            if os.path.isfile(fn):
		with open(fn) as fd:
		    data = fd.read()
		lines,words,chars = get_count(data)
		print_wc(option,lines,words,chars,fn)
		total_lines += lines
		total_words += words
		total_chars += chars
	    elif os.path.isdir(fn):
		print >> sys.stderr, "%s is a directory" % fn
	    else:
	        sys.stderr.write("%s No such file or directory\n" %fn)
	if len(args) > 1 and not option.total:
	    print_wc(option,total_lines,total_words,total_chars,'total') 
    else:
	data = sys.stdin.read()
	fn = ''
        lines,words,chars = get_count(data)
	print_wc(option,lines,words,chars,fn)

if __name__ == '__main__':
    main()
