#!/usr/bin/node

console.log("The arguments passed are:");

// print count and current argument
for(var count=0; count < WScript.Arguments.length; count++) { 
  console.log(" item " + (count+1) + ": " + WScript.Arguments.Item(count)); 
}
