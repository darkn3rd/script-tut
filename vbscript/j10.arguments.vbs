Set args = Wscript.Arguments
count = 1

WScript.Echo "The arguemnts passed are:"
For Each arg In args

  WScript.Echo " item " & count & ": " & arg
  count = count + 1
Next