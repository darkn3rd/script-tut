#!/usr/bin/env pash
# create function (subroutine)
Function Add-Nums ($nums)
{
   foreach($num in $nums) { $sum += $num }  # interate and sum up nums
   $sum                                     # return $sum
}

"The numbers to be added are 5, 2, 4, 3, 6."
# call the function (subroutine)
$result = Add-Nums 5, 2, 4, 3, 6
# output results
"The result of their summation is: $result."
