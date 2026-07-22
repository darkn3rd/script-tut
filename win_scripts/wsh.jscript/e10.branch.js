// prompt and read response
WScript.stdout.write("Would you like a toast? [Yes/No]: ");
response = WScript.stdin.readline();

// test response using the ternary operator
WScript.Echo(response == "Yes" ? "That's great!" : "How about a muffin?");
