#!/usr/bin/env pash

# declare some binding variables
$pond     = 500 # pond contains some available fish
$captured = 0   # captured represents fish capture
# utility variable, contains message for output
$notice   = "Fishing from the main pond... We now have {0} in the main pond.\n"

# create subroutine called Fish
Function Fish
{
   $pond -= 150 # subtract fish from global pond
   $captured += 150 # add to the fish captured
}

# output intial amount of fish in shared resource    
"We have {0} in this pond.\n" -f pond

Fish             # get some fish
$notice -f $pond # output result

Fish             # get some fish
$notice -f $pond # output result

Fish             # get some fish
$notice -f $pond # output result

# output result of fish captured from shared resource
"We now have a total of {0} fish captured\n" -f $captured