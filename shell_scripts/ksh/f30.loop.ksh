#!/usr/bin/env ksh
# spin loop as always true, break exits loop 
while [[ 1 ]]; do
   print -n "Enter your name (quit to exit): " # prompt
   read answer                                  # get input
   if [[ $answer = "quit" ]] ; then break; fi     # exit loop if user quits
   print Hello $answer!                           # output results as not exiting
done
