#!/usr/bin/env -S awk -f
BEGIN { 
  printf "Enter your name: "  # print prompt without newline
  getline name             # grab input
  print "Hello " name "!"  # output result with newline
}
