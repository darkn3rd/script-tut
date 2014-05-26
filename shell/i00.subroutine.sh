#!/bin/sh
 
# create function (subroutine)
show_date() {
  echo Today is $(date +"%b %d, %Y").
}
 
# call the function (subroutine)
show_date
