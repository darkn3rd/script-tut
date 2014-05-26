#!/usr/bin/python

# create method (function)
def add (*numbers):
   sum = 0                            # initialize starting sum value
   for num in numbers:                # iterate
      sum += num                      # sum up nums
   return sum                         # return the sum

# call the method (function)
result = add(5, 2, 4, 3, 6)

# output results
print "The result of summation is: %d." % result