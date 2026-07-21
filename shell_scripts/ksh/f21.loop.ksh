#!/usr/bin/env ksh
# conditional loop with while
while [[ "$answer" != "quit" ]]; do
   print -n "Enter your name (quit to Exit): " # prompt
   read answer                                  # get input
   if [[ $answer != "quit" ]] ; then              # print if not exiting
    print Hello $answer!
   fi
done
