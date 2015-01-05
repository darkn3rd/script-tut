#!/usr/bin/env bash
# collection loop fed each line of output from subshell
for item in $(ls); do                  # cycle through directory listing
   if [[ -d $item ]]; then             # test if path is directory
      echo "$item is a directory"
   else
      echo "$item is not a directory"
   fi
done
