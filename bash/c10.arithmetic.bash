#!/bin/ksh
# illustrative variables
true=1; false=0

# calculate result
result=$(($true && $false || $true))

# output result
echo "The statement (true AND false OR true) is $result"
