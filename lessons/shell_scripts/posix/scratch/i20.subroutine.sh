#!/bin/sh

# create subroutine
fish_farm() {
  local fish=500 
}


fish=10000

# call the subroutine
echo "Fish Before: $fish"
fish_farm
echo "Fish After : $fish"
