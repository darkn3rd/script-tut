#!/bin/sh

# create subroutine
fish_boat() {
  fish=500 
}


fish=10000

# call the subroutine
echo "Fish Before: $fish"
fish_boat
echo "Fish After : $fish"
