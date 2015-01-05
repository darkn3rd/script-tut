#!/usr/bin/env bash
# conditional loop until until...done block
until [[ "$answer" = "quit" ]]; do
   read -p "Enter your name (quit to exit): " answer # prompt and get input
   if [[ $answer != "quit" ]] ; then                 # echo if not exiting
    echo "Hello $answer!"
   fi
done
