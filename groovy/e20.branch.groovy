#!/usr/bin/env groovy
# prompt, get input, and convert to integer
number = int(raw_input("Input a number: "))

# test number range 
if number > 0:
  print "Number is greater than 0"
elif number < 0:
  print "Number is less than 0"
else:
  print "Number is 0"
