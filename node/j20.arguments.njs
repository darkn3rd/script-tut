#!/usr/bin/node

console.log("The arguments passed are (reverse order):");

// print count and current argument
for(var count=WScript.Arguments.length; count > 0; count--) { 
  console.log(" item " + (count) + ": " + WScript.Arguments.Item(count-1)); 
}
