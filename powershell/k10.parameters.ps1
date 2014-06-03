# create function (subroutine)
Function Add-Nums ($nums)
{
   foreach($num in $nums) { $sum += $num }  # interate and sum up nums
   Write-Host "The summation is: ${sum}."   # output results
}

# call the function (subroutine)
Add-Nums 5, 2, 4, 3, 6