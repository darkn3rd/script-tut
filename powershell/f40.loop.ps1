# spin loop as always true, break to exit
#   skip if no answer is entered
do {
  # prompt user
  $answer = Read-Host "Enter your name (quit to Exit)"
  
  # skip loop if nothing entered
  if ($answer -match "^$") { continue }
  
  # exit loop when user chooses to quit
  if ( $answer -eq "quit" ) { break }
  
  # output result if we got this far
  "Hello $answer!"
}
while (1)