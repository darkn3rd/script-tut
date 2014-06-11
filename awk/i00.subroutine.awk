#!/bin/awk -f

# create subroutine (function)
function show_date()
{
    "date +\"%B %d, %Y\"" | getline date   # fetch date
 
    # output results
    print "Today is " date
}

BEGIN {
  show_date()        # call subroutine (function)
}
