#!/bin/ksh
# conditional loop with while 
while [[ "$answer" != "quit" ]]; do
   read answer?"Enter your name (quit to exit): " # prompt and get input
   if [[ $answer != "quit" ]] ; then              # print if not exiting
    print Hello $answer!
   fi
done
