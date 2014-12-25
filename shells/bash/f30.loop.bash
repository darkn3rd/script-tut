#!/usr/bin/env bash
# spin loop as always true
while [[ true ]]; do
   # output prompt and get input
   read -p "Enter your name (quit to exit): " answer

   if [[ $answer = "quit" ]] ; then                 
     break                           # exit loop if user quits
   fi

   echo "Hello $answer!"             # output result as not exiting
done
