#!/usr/bin/env sh
# spin loop with break used to exit from loop
while [ 1 ]; do
   # output prompt using external printf command
   printf "Enter your name (quit to exit): "
   read answer         # get input
   
   # exit loop if user wants to quit
   if [ $answer = "quit" ] ; then
     break   
   fi
   
   echo Hello $answer! # output result as exiting
done