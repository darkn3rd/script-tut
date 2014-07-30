#!/bin/awk -f
BEGIN {
  # no collection loop in AWK that can be used to extract data from subshell
  #   alternative is to use conditional loop and buffered 
  #   input, pulled until EOF
  while ("ls -l" | getline) {
    # use the last field $NF as this is file name
    if (/^d/) print $NF " is a directory"  
    else print $NF " is a not a directory"
  }
}