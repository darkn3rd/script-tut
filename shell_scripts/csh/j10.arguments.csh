#!/usr/bin/env tcsh
echo "The arguments passed are:"
# print count and current argument
foreach arg ($argv[1-])
  @ count ++                  # increment count, starting from 0
  echo ' item '$count':' $arg # output result
end
# ^ newline must follow end of loop or it fails