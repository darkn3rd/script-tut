#!/usr/bin/tclsh
# while loop until user quits
while {true} {
  puts -nonewline "Enter you name (quit to Exit): "
  flush stdout
  gets stdin answer
 
  if {$answer == "quit"} {
      break
  } else {
      puts "Hello $answer"
  }
}
