#!/usr/bin/env tclsh
set answer ""  ;# must initialize answer

# conditional loop
while {$answer != "quit"} {
  # send prompt to buffer
  puts -nonewline "Enter your name (quit to Exit): "
  flush stdout       ;# output the buffer
  gets stdin answer  ;# get intput

  # output results if not exiting
  if {$answer != "quit"} { puts "Hello $answer!" }
}
