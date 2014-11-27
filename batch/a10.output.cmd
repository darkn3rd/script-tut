# output message to standard error
#  Note: Test by redirecting stdout to nowhere, e.g.
#   script > NUL
@ECHO "This is a test of the emergency script system."^
      "This is only a test." 2>&1
