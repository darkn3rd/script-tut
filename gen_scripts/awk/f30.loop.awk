#!/usr/bin/env awk -f
BEGIN {
  # spin loop as always true, break to exit loop
  do {
    printf "Enter your name (quit to exit): " # output prompt
    getline answer                            # get input
    # exit loop if exiting
    if (answer == "quit") break

    # output result as not exiting
    print "Hello " answer "!"
  } while ( 1 )
}
