#!/bin/awk -f
BEGIN {
  # spin loop as always true, break to exit loop
  do {
    printf "Enter your name (quit to exit): " # output prompt
    getline answer                            # get input

    # skip loop if not answer given
    if (answer ~ /^ *$/) continue

    # exit loop if exiting
    if (answer == "quit") break

    # output result as not exiting
    print "Hello " answer "!"
  } while ( 1 )
}
