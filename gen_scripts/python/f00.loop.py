#!/usr/bin/env python
import os

# collection loop on buffered output from subshell
for item in os.popen("ls dirtest").readlines():
  # test if item is directory
  path = "dirtest/" + item
  if os.path.isdir(path.rstrip()):
    print "%s is a directory" % item.rstrip()
  else:
    print "%s is not a directory" % item.rstrip()
