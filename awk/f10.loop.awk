#!/bin/awk -f
BEGIN {
  do {
    printf "Enter your name (quit to exit): "
    getline answer
    if (answer != "quit") print "Hello " answer
  } while ( answer != "quit" )
}
