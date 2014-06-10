#!/bin/awk -f
BEGIN { 
  printf "Enter a name: "  # print prompt without newline
  getline name             # grab input
  print "Hello " name      # output result with newline
}
