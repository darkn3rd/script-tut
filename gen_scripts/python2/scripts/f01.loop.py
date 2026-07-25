#!/usr/bin/env python2
# testbox: title="os.listdir() with for..in collection"
import os

# collection loop on directory listing from Python's own os.listdir(),
#  without a subshell - see f00.loop.py for the subshell (`ls`) version
#  of this same lesson
for item in sorted(os.listdir("dirtest")):
  path = "dirtest/" + item
  if os.path.isdir(path):
    print "%s is a directory" % item
  else:
    print "%s is not a directory" % item
