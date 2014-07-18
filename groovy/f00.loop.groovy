#!/usr/bin/env groovy
import os
 
# collection loop on buffered output from subshell
for item in os.popen("ls").readlines():
  # test if item is directory	
  if os.path.isdir(item.rstrip()):
    print "%s is a directory." % item.rstrip()
  else:
    print "%s is not a directory." % item.rstrip()