' illustrative variables
last  = Wscript.Arguments.Count - 1 ' get index of last element
first = 0                           ' get index of first element

WScript.Echo "The arguments passed are:"
' count style loop to generate index
For count = first To last
  ' retrieve argument using index
  arg =  WScript.Arguments.Item(count)
  ' output count and corresponding argument item
  WScript.Echo " item " & (count+1) & ": " & arg
Next