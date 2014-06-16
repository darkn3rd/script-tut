#!/usr/bin/php
<?php
// create function
function addNums()
{
   $numbers = func_get_args();    // retrieve variable number of numbers
   $sum = 0;                      // initalize to 0

   // add all nums in array 
   foreach ($numbers as $num) $sum += $num;             
 
   return $sum;                   // return result
}

// call the function
$result = addNums(5, 2, 4, 3, 6); // pass variable number of numbers

# output results with resulting integer
echo "The result of summation is: $result.\n";
?>