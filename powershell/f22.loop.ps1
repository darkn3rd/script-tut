# conditional loop with while
while ($answer -ne "quit") {
  # prompt user
  $answer = Read-Host "Enter your name (quit to Exit)"
  
  if ( $answer -ne "quit" ) { 
    "Hello $answer!" 
  } 
}