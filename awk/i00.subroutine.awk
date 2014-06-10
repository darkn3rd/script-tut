#!/bin/awk -f

# **************************************
# show_date () - shows current date using external date command 
# **************************************
function show_date()
{
    "date +\"%B %d, %Y\"" | getline date   # fetch date
 
    # output results
    print "Today is " date
}

# **************************************
#  main area 
# **************************************
BEGIN {
  show_date()
}
