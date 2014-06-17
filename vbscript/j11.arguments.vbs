last  = Wscript.Arguments.Count - 1 ' get index of last element
first = 0                           ' get index of first element

WScript.Echo "The arguments passed are (reverse order):"
' iterative loop from # of args to 1
For count = first To last
  ' output count and corresponding argument item
  WScript.Echo " item " & (Count+1) & ": " & WScript.Arguments.Item(Count)
next