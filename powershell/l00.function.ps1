# create function (subroutine)
Function Add-Nums ($nums)
{
   foreach($num in $nums) { $sum += $num }  # interate and sum up nums
   $sum
}

# call the function (subroutine)
$result = Add-Nums 5, 2, 4, 3, 6
# output results
"The result of summation is: $result."