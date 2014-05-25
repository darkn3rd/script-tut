#!/bin/sh
#until construction
until [ "$answer" = "quit" ]; do
   echo -n "Enter your name (quit to exit) "
   read answer
   if [ $answer != "quit" ] ; then
    echo Hello $answer
   fi
done