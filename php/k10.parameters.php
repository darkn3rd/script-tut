#!/usr/bin/php
<?php
// create subroutine
function addNums()
{
   $numbers = func_get_args(); // retrieve variable number of numbers
   $sum = 0;                   // initalize to 0

   foreach ($numbers as $num)  
     $sum += $num;             // add all nums in array 
 
   // output results
   echo "The summation is: $sum\n";
}

// call the subroutine (function)
addNums(5, 2, 4, 3, 6);        // pass variable number of numbers

?>