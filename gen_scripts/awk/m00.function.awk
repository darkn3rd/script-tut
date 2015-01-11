#!/usr/bin/env awk -f
# create the function
function addNums(numbers)
{
   sum = 0                 # initalize to 0
   for (num in numbers) {
     sum += numbers[num]   # add all nums in array
   }

   return sum              # return result
}

BEGIN {
  # build dynamic list of params
  string  = "5 2 4 3 6"    # declare string of params
  split(string, array)     # make into array of params

  # call the function
  result = addNums(array)  # pass array of dynamic params

  # output results with resulting integer
  print "The result of summation is: " result
}
