#!/bin/tcsh
set answer = ""                             # required to create initial var 
 
# loop conditionally until user quits
while ("$answer" != "quit")
  echo -n "Enter you name (quit to Exit): " # print prompt & acquire input
  set answer=$<                             # acquire input
 
  if ($answer != "quit") then
      echo " Hello $answer!"                # output result using variable
  endif
end  
# ^ required newline to end block