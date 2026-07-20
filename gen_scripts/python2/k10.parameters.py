#!/usr/bin/env python

# create the subroutine
def addNums (*numbers):
   sum = 0                            # initialize starting sum value
   for num in numbers:                # collection loop to get each number
      sum += num                      # sum up nums
   print "The summation is: %d" % sum # output results


# call the subroutine
addNums(5, 2, 4, 3, 6)   # pass a series of numbers
