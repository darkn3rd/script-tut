#!/usr/bin/node

// create subroutine
function addNums(numbers) 
{
  var sum = 0;

  for (var num in numbers)
    sum += numbers[num];

  console.log("The summation is " + sum + ".");  // output result
}

// cal the subroutine 
addNums([5,2,4,3,6])
