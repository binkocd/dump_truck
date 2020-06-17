#! /usr/bin/python3
# movedir.py - moves directories based on specified criteria
#              came from a need to move a bunch of directories
#              with trailing ' -' that rsync didn't like.

import os
import re

# TODO: find all directories with ' -' in their names
# 2011-09-11-
# 2011-10-11 -
dirDashRegex = re.compile(r'(\d\d\d\d-\d\d-\d\d -)')
dirNoDashRegex = re.compile(r'(\d\d\d\d-\d\d-\d\d-)')

#d = '/mnt/nas/Media/Photos/Josh\'s/google photos/Takeout/Google Photos'
d = '.'

for o in os.listdir(d):
    directories = dirDashRegex.findall(o)
    dashSrc = []
    for i in directories:
        dashSrc.append(directories[0])


# TODO: rename them
# os.rename(src, dst)
        dashDst = dashSrc[0][:-2]
        #noDashDst = noDashsrc[0][:-1]
        if not os.path.exists(dashDst):
            #print("Source: %s\nDestination: %s\n\n" % (dashSrc[0], dashDst))
            os.rename(dashSrc[0], dashDst)
        else:
            print("%s exists. % \dashDst")
