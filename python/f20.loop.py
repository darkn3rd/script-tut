#!/usr/bin/python
import os
 
# for...in construction
for item in os.popen("ls").readlines():
  if os.path.isdir(item.rstrip()):
    print "%s is a directory." % item.rstrip()
  else:
    print "%s is not a directory." % item.rstrip()