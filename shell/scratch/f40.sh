#!/bin/sh
# spin loop with break used to exit from loop
while [ 1 ]; do
   # output prompt using external printf command
   printf "Enter your name (quit to exit): "
   read answer         # get input
   
   if echo "$answer" | grep -q '^[[:blank:]]*$'; then continue; fi
   
   if [ "$answer" = "quit" ] ; then break; fi
   
   echo Hello $answer! # output result as exiting
done
