#!/usr/bin/python

import os, time

# this next line needs to be changed to take an argument
file="~/test.txt"
secsday=86400

st=os.stat(file)
age=(time.time() - st.st_ctime)
diff=int(age/secsday)

# the display needs to be made simple, the unit of meaurement needs to be parameterised
# the program needs to report an error on the os.stat commandi

#if diff = 1 DAYS = day
DAYS="days"
print "The file is %s %s old" % (diff, DAYS)
# therfore age/sescsday should give the age since the file was last modified.
