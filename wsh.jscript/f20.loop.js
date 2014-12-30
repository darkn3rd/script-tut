// conditional loop with do..while construct
do {
  // prompt user
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();         // get input
  if (answer != "quit")  
      WScript.echo("Hello " + answer + "!"); // output result if not exiting
} while (answer != "quit")
