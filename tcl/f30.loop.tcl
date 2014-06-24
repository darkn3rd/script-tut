#!/usr/bin/tclsh
# spin loop with break to exit loop
while {true} {
  # send prompt to buffer
  puts -nonewline "Enter you name (quit to Exit): "
  flush stdout       ;# output the buffer
  gets stdin answer  ;# get intput
 
  if {$answer == "quit"} {
      break                ;# exit loop if user quits
  } else {
      puts "Hello $answer" ;# output results as not exiting
  }
}
