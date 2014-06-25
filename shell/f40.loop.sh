#!/bin/sh
# spin loop with break used to exit from loop
while [ 1 ]; do
   # output prompt using external printf command
   printf "Enter your name (quit to exit): "
   read answer         # get input
   
   
   if [  $(echo "$answer" | grep '^[[:blank:]]*$') ]; then
     echo "got blank"
     #continue          # skip loop if no answer
   fi
   
   
   if [ "$answer" = "quit" ] ; then
     break             # exit loop if user wants to quit
   fi
   
   echo Hello $answer! # output result as exiting
done