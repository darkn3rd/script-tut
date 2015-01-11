#!/usr/bin/env tcsh
# illustrative variables
set true = 1
set false = 0

# calculate boolean result
@ result = ($true & $false | $true)

# output boolean result
echo "The statement (true AND false OR true) is: $result"
