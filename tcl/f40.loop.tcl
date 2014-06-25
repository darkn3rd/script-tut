#!/usr/bin/tclsh
# spin loop with break to exit loop, continue to skip loop
while {true} {
  # send prompt to buffer
  puts -nonewline "Enter you name (quit to Exit): "
  flush stdout         ;# output the buffer
  gets stdin answer    ;# get intput
 
  # skip loop if no answer entered
  if {[regexp {^[\s\t]*$} $answer]} { continue }
  # exit loop if user quits
  if {$answer == "quit"} { break } 
  
  puts "Hello $answer!" ;# output results as not exiting
}
