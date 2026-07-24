#!/usr/bin/env pash
# conditional loop with while
while ($answer -ne "quit") {
  # prompt user
  # Read-Host echoes back piped/redirected input - see d00.input.ps1
  Write-Host -NoNewline "Enter your name (quit to Exit): "
  $answer = [Console]::In.ReadLine()
  
  if ( $answer -ne "quit" ) { 
    "Hello $answer!" 
  } 
}
