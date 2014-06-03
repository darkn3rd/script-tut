count = 1

WScript.Echo "The arguemnts passed are:"
For Each arg In  Wscript.Arguments
           ' collection loop
  WScript.Echo " item " & count & ": " & arg ' print count and current argument
  count = count + 1                          ' increment count
Next