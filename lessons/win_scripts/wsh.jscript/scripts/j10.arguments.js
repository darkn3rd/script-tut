WScript.Echo("The arguments passed are:");

// print count and current argument
for(var count=0; count < WScript.Arguments.length; count++) { 
  WScript.Echo(" item " + (count+1) + ": " + WScript.Arguments.Item(count)); 
}
