#!/usr/bin/env bash
# conditional loop until until...done block
until [[ "$answer" = "quit" ]]; do
   printf "%s" "Enter your name (quit to Exit): " # prompt
   read answer                                     # get input
   if [[ $answer != "quit" ]] ; then                 # echo if not exiting
    echo "Hello $answer!"
   fi
done
