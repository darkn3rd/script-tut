#!/bin/tcsh
@ count = 10

# emulate iterative loop using conditional loop
while ($count > 0)
 echo " Count is $count" # print curent count
 @ count --
end
# ^ newline needed for block