// prompt and read 1 character
WScript.stdout.write("Input a character: ");
keypress = WScript.stdin.read(1);

// find match and print result
switch (true) {
  case match("[a-z]", keypress):
    WScript.Echo("Lowercase letter");
    break;
  case match("[A-Z]", keypress):
    WScript.Echo("Uppercase letter");
    break;
  case match("[0-9]", keypress):
    WScript.Echo("Digit");
    break;
  default:
    WScript.Echo("Punctuation, whitespace, or other");
}

// match() - returns true if pattern found in string
function match(pattern, string) 
{
  var re = new RegExp(pattern);
  return re.test(string);
}
