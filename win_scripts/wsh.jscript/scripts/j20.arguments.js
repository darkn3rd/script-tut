WScript.Echo("The arguments passed are (reverse order):");

// print count and current argument
for(var count=WScript.Arguments.length; count > 0; count--) { 
  WScript.Echo(" item " + (count) + ": " + WScript.Arguments.Item(count-1)); 
}
