#!/bin/ksh
# loop through listing with for/in/do...done
for item in $(ls); do                  # cycle through directory listing
   if [[ -d $item ]]; then             # test if path is directory
      print "$item is a directory"
   else
      print "$item is not a directory"
   fi
done
