#!/usr/bin/node
// prompt and read one character
WScript.stdout.write("Input a character: ");
keypress = WScript.stdin.read(1);

// find RegExp and print result
if (RegExp("[a-z]").test(keypress)) 
    console.log("Lowercase letter");
else if (RegExp("[A-Z]").test(keypress)) 
   console.log("Uppercase letter");
else if (RegExp("[0-9]").test(keypress)) 
    console.log("Digit");
else 
    console.log("Punctuation, whitespace, or other");
