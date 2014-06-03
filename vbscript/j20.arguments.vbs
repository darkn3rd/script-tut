WScript.Echo "The arguments passed are (reverse order):"
' iterative loop from # of args to 1
For count = (Wscript.Arguments.Count) To 1 step -1
  ' output count and corresponding argument item
  WScript.Echo " item " & count & ": " & WScript.Arguments.Item(count-1)
next