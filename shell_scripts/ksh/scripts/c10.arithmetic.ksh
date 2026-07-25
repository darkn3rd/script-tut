#!/usr/bin/env ksh
# utility variables
true=1; false=0

# calculate result
result=$(($true && $false || $true))

# output result
print "The statement (true AND false OR true) is: $result"
