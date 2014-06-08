#!/bin/sh
echo -n "Input a character: " ; read Keypress
 
# if construction
# Note that POSIX Shell does not support POSIX character class expressions
#  As POSIX tr supports POSIX character class expression, this is workaround
if [ -z $(echo $Keypress | tr -d "[:lower:]") ]; then
  echo "Lowercase letter"
elif [ -z $(echo $Keypress | tr -d "[:upper:]") ]; then
  echo "Uppercase letter"
elif [ -z $(echo $Keypress | tr -d  "[:digit:]") ]; then
  echo "Digit"
else
  echo "Punctuation, whitepace, or other"
fi
