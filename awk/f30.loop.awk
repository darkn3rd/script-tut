#!/bin/awk -f
BEGIN {
  # spin loop as always true, break to exit loop
  do {
    printf "Enter your name (quit to exit): " # output prompt
    getline answer                # get input
    if (answer == "quit")         # exit?
      break                       # exit loop if exiting
    else
      print "Hello " answer "!"   # output result is not exiting
  } while ( 1 )
}
