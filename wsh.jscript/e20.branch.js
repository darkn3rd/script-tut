// prompt and read one character
WScript.stdout.write("Input a character: ");
keypress = WScript.stdin.read(1);

// find RegExp and print result
if (RegExp("[a-z]").test(keypress)) 
    WScript.Echo("Lowercase letter");
else if (RegExp("[A-Z]").test(keypress)) 
   WScript.Echo("Uppercase letter");
else if (RegExp("[0-9]").test(keypress)) 
    WScript.Echo("Digit");
else 
    WScript.Echo("Punctuation, whitespace, or other");
