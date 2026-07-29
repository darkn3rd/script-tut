' create function
Function AddNums(args)
  For Each num In args  ' iterate through each argument
    sum = sum + num     ' sum up all the numbers
  Next

  AddNums = sum         ' set return to sum
End Function

' call the function
nums = Array(5,2,4,3,6)
result = AddNums(nums)

WScript.Echo "The numbers to be added are " & Join(nums, ", ") & "."
WScript.Echo "The result of their summation is: " & result & "."

