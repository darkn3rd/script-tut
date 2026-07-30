#!/usr/bin/env bash

# declare some variables
pond=500   # pond contains some available fish
captured=0 # captured represents fish capture

# create subroutine (function)
function fish {
  local pond=500                 # local pond shadows the global; changes here never escape
  pond=$(( pond - 150 ))         # subtract from local pond only
  captured=$(( captured + 150 )) # captured has no local decl, so this still modifies the global
}

# output initial amount of fish in shared resource
echo "We have $pond in this pond."

fish # get some fish
echo "Fishing from a local pond... We now have $pond in the main pond."

fish # get some fish
echo "Fishing from a local pond... We now have $pond in the main pond."

fish # get some fish
echo "Fishing from a local pond... We now have $pond in the main pond."

# output result of fish captured from local resource
echo "We now have a total of $captured fish captured"
