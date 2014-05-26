#!/usr/bin/python

# create method (subroutine)
def add (*numbers):
   sum = 0                            # initialize starting sum value
   for num in numbers:                # iterate
      sum += num                      # sum up nums
   print "The summation is: %d" % sum # output results


# call the method (subroutine)
add(5, 2, 4, 3, 6)