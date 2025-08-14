#!/bin/bash

#v1.0

# written for bash/wsl

# set source directory
TDIR="/mnt/c/Users/davel/OneDrive - GMB/C. Casework"
echo ${TDIR}
cd "${TDIR}"

# with no param $1, then print else delete

if [ -z $1 ];then
    action="-print"
else
    action="-delete"
fi
echo action is $action
tooold=730; # two years

# probably needs a -depth parameter, or touch stuff you know you want to keep
# Delete files older than 2 years -delete
find "${TDIR}" -type f -mtime +730 ${action}

# Delete empty directories
find "${TDIR}" -type d -empty ${action}
