#!/usr/bin/env tcsh
# output message to standard error
#  Note: Test by redirecting stdout to nowhere, e.g.
#   script > /dev/null
#  Requirements: stderr device file
echo "This is a test of the emergency script system." \
     "  This is only a test." > /dev/stderr
