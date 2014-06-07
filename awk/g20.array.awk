#!/bin/awk -f
BEGIN {
  while ("ls -l" | getline) {
    if (/^d/) print $9 " is a directory"
    else print $9 " is a not a directory"
  }
}
