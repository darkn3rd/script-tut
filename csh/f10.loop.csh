#!/bin/tcsh
@ count = 10             # initialize counter

# count style loop using while
while ($count > 0)
 echo " Count is $count" # print curent count
 @ count --
end
# ^ newline needed for block