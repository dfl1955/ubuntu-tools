#!/usr/bin/python

# Author : Dave Levy    Version : 1.0    Date : 2 Apr 2015

# takes the command line arguments and outputs a quote enclosed string

import sys

q='"'
s = q + ' '.join(sys.argv[1:]) + q
print s

