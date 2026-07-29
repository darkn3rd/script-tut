#!/usr/bin/env zsh
# spin loop as always true
while [[ true ]]; do
   # output prompt and get input
   printf "%s" "Enter your name (quit to exit): "
   read answer

   if [[ $answer = "quit" ]] ; then                 
     break                           # exit loop if user quits
   fi

   echo "Hello $answer!"             # output result as not exiting
done
