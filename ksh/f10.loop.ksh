#!/bin/ksh
# loop until user exits using until/do...done construction
until [[ "$answer" = "quit" ]]; do
   read answer?"Enter your name (quit to exit): " # prompt and get input
   if [[ $answer != "quit" ]] ; then              # print if not exiting
    print Hello $answer
   fi
done
