// prompt and read 1 character
WScript.stdout.write("Input a character: ");
keypress = WScript.stdin.read(1);

// find match and print result
switch (true) {
  case RegExp("[a-z]").test(keypress):
    WScript.Echo("Lowercase letter");
    break;
  case RegExp("[A-Z]").test(keypress):
    WScript.Echo("Uppercase letter");
    break;
  case RegExp("[0-9]").test(keypress):
    WScript.Echo("Digit");
    break;
  default:
    WScript.Echo("Punctuation, whitespace, or other");
}
