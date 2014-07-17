#!/bin/ksh
read keypress?"Input a character: " # prompt user and get input
keypress=${keypress:0:1}            # substring for only 1st char
 
# case construction 
#   with support for POSIX character class expressions
case "$keypress" in
  [[:lower:]] ) print "Lowercase letter";;
  [[:upper:]] ) print "Uppercase letter";;
  [[:digit:]] ) print "Digit";;
            * ) print "Punctuation, whitespace, or other";;
esac
