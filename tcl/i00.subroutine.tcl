#!/usr/bin/tclsh

# create subroutine
proc show_date {} {
  # output date in readable format
  puts "Today is [clock format [clock seconds] -format {%B %d, %Y}]" 
}

# call subroutine
show_date

