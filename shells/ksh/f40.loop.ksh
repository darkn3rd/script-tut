#!/bin/ksh
# spin loop as always true, break exits loop 
while [[ 1 ]]; do
   # prompt and get input
   read answer?"Enter your name (quit to exit): " 
   # check for answer
   if [[ $answer = ~(E)(^[ \t]*$) ]]; then 
	  continue           # skip loop if no answer
   fi
   # determien if user wants to quit
   if [[ $answer = "quit" ]] ; then 
	  break              # exit loop if user quits
   fi

   print Hello $answer!  # output results as not exiting
done
