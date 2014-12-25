#!/usr/bin/env ksh
read keypress?"Input a character: " # prompt & get input
keypress=${keypress:0:1}            # substring for only 1st char
 
# test if keypress matches pattern
#  with ASCII character class expressions
if [[ $keypress = [a-z] ]]; then
  print "Lowercase letter"
elif [[ $keypress = [A-Z] ]]; then
  print "Uppercase letter"
elif [[ $keypress = [0-9] ]]; then
  print "Digit"
else
  print "Punctuation, whitepace, or other"
fi
