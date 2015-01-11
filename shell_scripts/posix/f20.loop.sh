#!/usr/bin/env sh
# conditional loop with negative test
until [ "$answer" = "quit" ]; do
   printf "Enter your name (quit to Exit): "
   read answer
   if [ $answer != "quit" ] ; then
    echo Hello $answer!
   fi
done
