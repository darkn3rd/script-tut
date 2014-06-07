#!/bin/awk -f
function add(nums)
{
   sum = 0                          # initalize to 0
   for (num in nums) { sum += num } # add all nums in array
 
   print "The summation is: " sum   # output results
}
 
BEGIN {
  # build dynamic list of params
  param_str  = "5 2 4 3 6"          # declare string of params
  split(param_str, param_list)      # make into array of params
 
  # call the function
  add(param_list)                   # pass array of dynamic params
}
