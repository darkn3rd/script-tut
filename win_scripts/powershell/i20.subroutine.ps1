#!/usr/bin/env pash

# declare some binding variables
$pond     = 500 # pond contains some available fish
$captured = 0   # captured represents fish capture
# utility variable, contains message for output
$notice   = "Fishing from a local pond... We now have {0} in the main pond."

# create subroutine called Fish
Function Fish
{
   $pond             = 500 # declare local variable
   $pond            -= 150 # subtract fish from global pond
   $global:captured += 150 # add to the fish captured
}

# output result of fish captured from local resource
"We have {0} in this pond." -f $pond

Fish             # get some fish
$notice -f $pond # output result

Fish             # get some fish
$notice -f $pond # output result

Fish             # get some fish
$notice -f $pond # output result

# output result of fish captured from shared resource
"We now have a total of {0} fish captured" -f $captured
