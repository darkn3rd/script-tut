#!/bin/sh
# illustrative variables
true=1; false=0
# calcualte boolean logic
result=$(($true && $false || $true))
# output results
echo "The statement (true AND false OR true) is $result"