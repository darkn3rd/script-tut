#!/usr/bin/env bash
# spin loop as always true
while [[ true ]]; do
   # output prompt and get input
   printf "%s" "Enter your name (quit to exit): "
   read answer

   if [[ $answer =~ ^[\s\t]*$ ]] ; then                 
     continue                        # skip loop if no answer
   fi

   if [[ $answer = "quit" ]] ; then                 
     break                           # exit loop if user quits
   fi

   echo "Hello $answer!"             # output result as not exiting
done
