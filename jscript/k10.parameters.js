' create subroutine
Sub add(args)
  For Each num In args
    sum = sum + num
  Next

  WScript.echo "The summation is " & sum & "."  ' output result
End Sub

' cal the subroutine 
add Array(5,2,4,3,6)
