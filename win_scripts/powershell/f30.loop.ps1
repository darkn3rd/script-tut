#!/usr/bin/env pash
# spin loop as always true, break to exit
do {
  # prompt user
  # Read-Host echoes back piped/redirected input - see d00.input.ps1
  Write-Host -NoNewline "Enter your name (quit to exit): "
  $answer = [Console]::In.ReadLine()
  
  # exit loop when user wants to quit
  if ( $answer -eq "quit" ) { break } 
  
  # output result if we got this far 
  "Hello $answer!" 
}
while (1)