#!/bin/bash
 
# create function (subroutine)
function show_date {
  echo Today is $(date +"%B %d, %Y").
}
 
# call the function (subroutine)
show_date
