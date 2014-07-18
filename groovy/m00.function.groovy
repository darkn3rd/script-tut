#!/usr/bin/env groovy
# create the function
def addNums (*numbers):
   sum = 0                            # initialize starting sum value
   for num in numbers:                # iterate
      sum += num                      # sum up nums
   return sum                         # return the sum

# output numbers before function
print "The numbers to be added are {}.".format((5, 2, 4, 3, 6))

# call the function
result = addNums(5, 2, 4, 3, 6)

# output results
print "The result of their summation is: %d." % result
