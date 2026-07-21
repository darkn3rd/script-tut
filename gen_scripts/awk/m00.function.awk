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

  # count elements and build ordered display string; split() guarantees
  #  array indices 1..count in the original order
  count = 0
  for (num in array) count++      # POSIX awk has no length(array)
  numbers = array[1]
  for (num = 2; num <= count; num++) numbers = numbers ", " array[num]
  print "The numbers to be added are " numbers "."

  # call the function
  result = addNums(array)  # pass array of dynamic params

  # output results with resulting integer
  print "The result of their summation is: " result "."
}
