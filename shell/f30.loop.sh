#!/bin/sh
# spin loop with break used to exit from loop
while [ 1 ]; do
   printf "Enter your name (quit to exit): "
   read answer
   if [ $answer != "quit" ] ; then
     echo Hello $answer!
   else 
     break   
   fi
done