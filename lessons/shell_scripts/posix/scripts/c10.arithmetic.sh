#!/usr/bin/env sh
# testbox: title="arithmetic context boolean logic via true/false=1/0 vars"
# illustrative variables
true=1; false=0
# calcualte boolean logic
result=$(($true && $false || $true))
# output results
echo "The statement (true AND false OR true) is: $result"
