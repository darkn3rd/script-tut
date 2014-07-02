#!/usr/bin/php
<?php
# output message to standard error
#  Note: Test by redirecting stdout to nowhere, e.g.
#   script > /dev/null
fwrite(STDERR, "This is a test of the emergency script system." .
	           "  This is only a test.")
?>

