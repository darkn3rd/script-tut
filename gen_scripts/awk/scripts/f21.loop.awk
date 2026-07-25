#!/usr/bin/env awk -f
BEGIN {
  # conditional loop with do...while construct
  while ( answer != "quit" ) {
    printf "Enter your name (quit to Exit): "  # output prompt
    getline answer                             # get input
    # output answer if not exiting
    if (answer != "quit") print "Hello " answer "!"
  }
}
