#!/usr/bin/env tclsh
# spin loop with break to exit loop
while {true} {
  # send prompt to buffer
  puts -nonewline "Enter you name (quit to Exit): "
  flush stdout         ;# output the buffer
  gets stdin answer    ;# get intput
  
  # exit loop if user quits
  if {$answer == "quit"} { break } 
  
  puts "Hello $answer!" ;# output results as not exiting
}
