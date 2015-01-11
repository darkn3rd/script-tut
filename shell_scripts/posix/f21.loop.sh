#!/usr/bin/env sh
# conditional loop with positive test
while [ "$answer" != "quit" ]; do
   printf "Enter your name (quit to Exit): "
   read answer
   if [ $answer != "quit" ] ; then
     echo Hello $answer!
   fi
done
