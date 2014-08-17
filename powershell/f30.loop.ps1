#!/usr/bin/env pash
# spin loop as always true, break to exit
do {
  # prompt user
  $answer = Read-Host "Enter your name (quit to Exit)"
  
  # exit loop when user wants to quit
  if ( $answer -eq "quit" ) { break } 
  
  # output result if we got this far 
  "Hello $answer!" 
}
while (1)