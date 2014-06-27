#!/bin/ksh
 
# create function (subroutine)
function show_date {
  print Today is $(date +"%B %d, %Y").
}
 
# call the function (subroutine)
show_date
