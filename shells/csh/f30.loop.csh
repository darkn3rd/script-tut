#!/bin/tcsh
set answer = ""                             # required to create initial var 
 
# spin loop as while always true
while (1)
  echo -n "Enter you name (quit to Exit): " # print prompt & acquire input
  set answer=$<                             # acquire input
 
  if ($answer == "quit") then
    break                                   # exit if user wants to quit
  endif
    
  echo " Hello $answer!"                    # output result as not exiting
end  
# ^ required newline to end block