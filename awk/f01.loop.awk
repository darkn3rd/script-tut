#!/bin/awk -f
BEGIN {
  # no collection loop to extract data from subshell
  #   alternative is to use conditional loop and buffered 
  #   input, pulled until EOF
  while ("ls -l" | getline) {
    if (/^d/) print $NF " is a directory"
    else print $NF " is a not a directory"
  }
}
