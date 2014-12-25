#!/usr/bin/env tcsh

# set count to max item in array
@ count = $#argv

# loop down toward 1
while ( $count > 0 )
  echo ' item '$count':' $argv[$count] # output result
  @ count --                           # decrement count
end
# ^ newline must follow end of loop or it fails