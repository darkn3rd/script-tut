#!/usr/bin/env -S awk -f
# create the subroutine (function)
function addNums(numbers,    num, count, sending, sum)
{
   count = 0
   for (num in numbers) count++   # POSIX awk has no length(array)

   # build ordered "Sending: ..." list; split() guarantees array
   #  indices 1..count in the original order
   sending = numbers[1]
   for (num = 2; num <= count; num++) sending = sending ", " numbers[num]
   print "Sending: " sending

   sum = 0
   for (num = 1; num <= count; num++) sum += numbers[num] # add all nums
   print "The summation is: " sum "."                     # output results
}

BEGIN {
  # build dynamic list of params
  string  = "5 2 4 3 6"           # declare string of params
  split(string, array)            # make into array of params

  # call the subroutine (function)
  addNums(array)                  # pass array of dynamic params
}
