#!/usr/bin/python
import sys
# output message to standard error
#  Note: Test by redirecting stdout to nowhere, e.g.
#   script > /dev/null
print >>sys.stderr, "This is a test of the emergency script system.  This is only a test."