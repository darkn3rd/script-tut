#!/bin/sh
string1="wow" ; string2="wow"
num1=15 ; num2=15
file1=/etc/passwd
 
# test a string using test
test "$string1" = "$string2" && echo Both strings are the same.
 
# test a string using [˽...˽]
[ "$string1" = "$string2" ] && echo Both strings are the same.
 
# test a file
[ -f $file1 ] && echo $file1 is a file
 
# test an integer equality
[ $num1 -eq $num2 ] && echo Both numbers are the same.
 
# test with reverse logic
[ ! $num1 -ne $num2 ] && echo Both numbers are not not equal.
 
# test with boolean AND condition
[ $num1 -gt 10 -a $num1 -lt 100 ] && echo num1 is between 10 and 100
 
# test with boolean OR condition
[ $num1 -gt 10 -o $num2 -lt 10 ] && echo num1 and num2 are greater than 10