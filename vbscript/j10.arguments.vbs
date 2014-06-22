' utility variables
Count = 1  ' initialize counter for output

WScript.Echo "The arguemnts passed are:"
' collection loop used to retreive each argument
For Each arg In Wscript.Arguments            ' collection loop
  WScript.Echo " item " & count & ": " & arg ' print count and current argument
  count = count + 1                          ' increment count
Next
