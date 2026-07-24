#!/usr/bin/env pash
# spin loop as always true, break to exit
#   skip if no answer is entered
do {
  # prompt user
  # Read-Host echoes back piped/redirected input - see d00.input.ps1
  Write-Host -NoNewline "Enter your name (quit to exit): "
  $answer = [Console]::In.ReadLine()
  
  # skip loop if nothing entered
  if ($answer -match "^$") { continue }
  
  # exit loop when user chooses to quit
  if ( $answer -eq "quit" ) { break }
  
  # output result if we got this far
  "Hello $answer!"
}
while (1)