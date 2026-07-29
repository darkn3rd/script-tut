#!/usr/bin/env bash

# declare some variables
pond=500   # pond contains some available fish
captured=0 # captured represents fish capture

# create subroutine (function); no special keyword needed to modify globals
function fish {
  pond=$(( pond - 150 ))         # subtract fish from global pond
  captured=$(( captured + 150 )) # add to the fish captured
}

# output initial amount of fish in shared resource
echo "We have $pond in this pond."

fish # get some fish
echo "Fishing from the main pond... We now have $pond in the main pond."

fish # get some fish
echo "Fishing from the main pond... We now have $pond in the main pond."

fish # get some fish
echo "Fishing from the main pond... We now have $pond in the main pond."

# output result of fish captured from shared resource
echo "We now have a total of $captured fish captured"
