#!/usr/bin/env awk -f
BEGIN {
  # no collection loop in AWK that can be used to extract data from subshell
  #   alternative is to use conditional loop and buffered
  #   input, pulled until EOF
  while ("ls -l dirtest" | getline) {
    # use the last field $NF as this is file name
    if (/^d/) print $NF " is a directory"
    else print $NF " is not a directory"
  }
}
