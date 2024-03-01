#!/usr/bin/python

import sys, getopt
import os, time

ifile=''


usage='tdiff.py file=filename'
try:
	opt, args = getopt.getopt(sys.argv, "f:", ["ifile="])
except  getopt.GetoptError:
	print sys.argv[0], 'file=filename'
	sys.exit(2)

ifname=args[1][(args[1].find('=') + 1):]

# test if ifname is a file

# needs to inherit directory

file="/opt/local/var/log/refresh/outdated.0"
file=ifname
secsday=86400

st = os.stat(file)

age=(time.time() - st.st_ctime)
diff=int(age/secsday)

print diff
