#!/usr/bin/env sh
# collection loop with subshell
for item in $(ls dirtest); do
   if [ -d "dirtest/$item" ]; then
      echo "$item is a directory"
   else
      echo "$item is not a directory"
   fi
done
