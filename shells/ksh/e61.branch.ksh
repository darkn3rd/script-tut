#!/usr/bin/env ksh
read keypress?"Input a character: " # prompt & get input
keypress=${keypress:0:1}            # substring for only 1st char
 
# test if keypress matches pattern
#  with support for POSIX character class expressions
if [[ $keypress = [[:lower:]] ]]; then
  print "Lowercase letter"
elif [[ $keypress = [[:upper:]] ]]; then
  print "Uppercase letter"
elif [[ $keypress = [[:digit:]] ]]; then
  print "Digit"
else
  print "Punctuation, whitepace, or other"
fi
