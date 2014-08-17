#!/usr/bin/env pash
# conditional loop with do...while
do {
  # prompt user
  $answer = Read-Host "Enter your name (quit to Exit)"
  
  if ( $answer -ne "quit" ) { 
    "Hello $answer!" 
  }
  
}
until ($answer -eq "quit")