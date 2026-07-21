#!/usr/bin/env ksh
print -n "Input a character: " # prompt user
read keypress                   # get input
keypress=${keypress:0:1}            # substring for only 1st char
 
# case construction 
#   with ASCII character class expressions
case "$keypress" in
  [a-z] ) print "Lowercase letter";;
  [A-Z] ) print "Uppercase letter";;
  [0-9] ) print "Digit";;
      * ) print "Punctuation, whitespace, or other";;
esac
