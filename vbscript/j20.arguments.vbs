last  = Wscript.Arguments.Count - 1 ' get index of last element
first = 0                           ' get index of first element

WScript.Echo "The arguments passed are (reverse order):"
' iterative loop from # of args to 1
For count = last To first step -1
  ' output count and corresponding argument item
  WScript.Echo " item " & (count+1) & ": " & WScript.Arguments.Item(count)
next