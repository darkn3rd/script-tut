#!/bin/awk -f
BEGIN {
  numbers[0] = 5
  numbers[1] = 1
  numbers[2] = 3

  newnumbers = getarray(numbers)
}

function getarray(n)
{
   n[3] = 2
   return n 
} 
