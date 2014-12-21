#!/bin/bash
# illustrative variables
TRUE=1; FALSE=0

# calculate result
result=$(( $TRUE && $FALSE || $TRUE ))

# output result
echo "The statement (true AND false OR true) is $result"