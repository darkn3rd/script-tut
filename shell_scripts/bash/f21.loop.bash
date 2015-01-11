#!/usr/bin/env bash
# conditional loop using while...done
while [[ "$answer" != "quit" ]]; do
   read -p "Enter your name (quit to Exit): " answer # prompt and get input
   if [[ $answer != "quit" ]] ; then                 # echo if not exiting
    echo "Hello $answer!"
   fi
done
