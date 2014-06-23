#!/bin/awk -f
BEGIN {
  # no collection loop to extract data from subshell
  #   alternative is to use conditional loop and buffered 
  #   input, pulled until EOF
  while ("ls -l" | getline) {
    if (/^d/) print $9 " is a directory"
    else print $9 " is a not a directory"
  }
}
