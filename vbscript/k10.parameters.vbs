' create subroutine
Sub addNums(nums)
  For Each num In nums
    sum = sum + num       ' sum the nums
  Next

  WScript.echo "The summation is " & sum & "."  ' output result
End Sub

' call the subroutine and pass anonymous Array object
addNums Array(5,2,4,3,6)
