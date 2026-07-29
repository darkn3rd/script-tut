// prompt and read response
WScript.stdout.write("Would you like a toast? [Yes/No]: ");
response = WScript.stdin.readline();

// test response to a string using if/else construction
if (response == "Yes")
  WScript.Echo("That's great!");
else
  WScript.Echo("How about a muffin?");
