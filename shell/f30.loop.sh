#!/bin/sh
#for...in construction
for item in $(ls); do
   if [ -d $item ]; then
      echo "$item is a directory"
   else
      echo "$item is not a directory"
   fi
done