#!/bin/awk -f
function addNums(numbers)
{
   sum = 0                             # initalize to 0
   for (num in numbers) { sum += num } # add all nums in array
 
   print "The summation is: " sum      # output results
}
 
BEGIN {
  # build dynamic list of params
  param_str  = "5 2 4 3 6"             # declare string of params
  split(param_str, param_list)         # make into array of params
 
  # call the function
  addNums(param_list)                  # pass array of dynamic params
}
