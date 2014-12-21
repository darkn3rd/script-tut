#!/bin/sh
# utility variables
true=1
false=0
# spin loop with break used to exit from loop
while [ $true ]; do
   # output prompt using external printf command
   printf "Enter your name (quit to exit): "
   read answer         # get input
  
   # search for blank result and save state as error code
   #   error codes
   #     0 = match found
   #     1 = no match found
   echo "$answer" | grep -q "^[[:blank:]]*$"
   # save error code for later use
   isError=$?

   # test error code from previous match
   if [ $isError = $false ]; then
     continue          # skip loop if no answer
   fi
   
   if [ "$answer" = "quit" ] ; then
     break             # exit loop if user wants to quit
   fi
   
   echo Hello $answer! # output result as exiting
done
