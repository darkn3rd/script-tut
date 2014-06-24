do {
  WScript.stdout.write("Enter your name (quit to Exit): ");
  answer = WScript.stdin.readline();
  if (answer != "quit")  
      WScript.echo("Hello " + answer + "!");
} while (answer != "quit")
