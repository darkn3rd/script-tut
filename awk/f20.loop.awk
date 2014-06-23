#!/bin/awk -f
BEGIN {
  # conditional loop with while construct
  do {
    printf "Enter your name (quit to exit): "  # output prompt
    getline answer                             # get input
    # print answer if not exiting
    if (answer != "quit") print "Hello " answer "!"
  } while ( answer != "quit" )
}
