#!/usr/bin/env python
import sys
# output message to standard error
#  Note: Test by redirecting stdout to nowhere; Examples:
#   Unix/Linux: python script > /dev/null
#   Windows:    python script > NUL
print >>sys.stderr, "This is a test of the emergency script system." + \
                    "  This is only a test."