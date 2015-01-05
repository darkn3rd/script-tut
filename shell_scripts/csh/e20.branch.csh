#!/usr/bin/env tcsh
# prompt user and get input
echo -n "Input a number: " # print prompt & acquire input
set number=$<              # acquire input

# test input and output result
if ( $number > 0 ) then
  echo Number is greater than 0
else if ( $number < 0 ) then
  echo Number is less than 0
else
  echo Number is 0
endif
# ^ newline required or failure