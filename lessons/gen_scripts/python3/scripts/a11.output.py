#!/usr/bin/env python3
import sys
# output message to standard error
#  Note: Test by redirecting stdout to nowhere; Examples:
#   Unix/Linux: python3 script > /dev/null
#   Windows:    python3 script > NUL
sys.stderr.write("This is a test of the emergency script system."
                  "  This is only a test.\n")
