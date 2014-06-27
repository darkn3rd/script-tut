#!/bin/ksh
# utility variables
true=1; false=0
# boolean logic
result=$(($true && $false || $true))
print "The statement (true AND false OR true) is $result"
