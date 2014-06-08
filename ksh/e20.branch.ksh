#!/bin/ksh
read keypress?"Input a character: " # prompt & get input
keypress=${keypress:0:1}            # substring for only 1st char
 
# test if keypress matches pattern
if [[ $keypress = [[:lower:]] ]]; then
  print "\nLowercase letter"
elif [[ $keypress = [[:upper:]] ]]; then
  print "\nUppercase letter"
elif [[ $keypress = [[:digit:]] ]]; then
  print "\nDigit"
else
  print "\nPunctuation, whitepace, or other"
fi
