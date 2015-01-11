#!/usr/bin/env awk -f
BEGIN {
  # conditional loop with while construct
  do {
    printf "Enter your name (quit to Exit): "  # output prompt
    getline answer                             # get input
    # print answer if not exiting
    if (answer != "quit") print "Hello " answer "!"
  } while ( answer != "quit" )
}
