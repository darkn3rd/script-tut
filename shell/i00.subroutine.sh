#!/bin/sh
 
# create function (subroutine)
show_date() {
  year=$(date +%Y)
  mon=$(date +%b)
  day=$(date +%d)
 
  echo "Today is $mon $day, $year"
}
 
# call the function (subroutine)
show_date