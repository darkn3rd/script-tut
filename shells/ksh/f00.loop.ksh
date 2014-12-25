#!/usr/bin/env ksh
# collection loop is fed each line from subshell 
for item in $(ls); do                  # cycle through directory listing
   if [[ -d $item ]]; then             # test if path is directory
      print "$item is a directory"
   else
      print "$item is not a directory"
   fi
done
