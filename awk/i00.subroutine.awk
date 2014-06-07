#!/bin/awk -f
 
function show_date()
{
    "date" | getline date   # fetch date
    split(date, items)      # split up date
 
    # output results
    printf "Today is %s %s %s.\n", items[2], items[3], items[4]
}
 
BEGIN {
  show_date()
}
