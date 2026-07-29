// JScript has no heredoc/triple-quote syntax - a "+"-continued chain of
//  single-quoted lines is the closest stand-in for a multi-line string
//  literal, all held in one variable and printed with a single call.
// The last line has no trailing "\n" - no linebreak before the answer.
var menu = 'Select an item from the menu.\n' +
           '\n' +
           '  1 - Coffee\n' +
           '  2 - Espresso\n' +
           '  3 - Latte\n' +
           '  4 - Machiato\n' +
           '  5 - Capucino\n' +
           '  6 - Mocha\n' +
           '  7 - Tea\n' +
           '\n' +
           'Make your selection: ';
WScript.stdout.write(menu);
selection = WScript.stdin.readline();

if (selection == 1)
   WScript.Echo("You selected a Coffee");
else if (selection == 2)
   WScript.Echo("You selected an Espresso");
else if (selection == 3)
   WScript.Echo("You selected a Latte");
else if (selection == 4)
   WScript.Echo("You selected a Machiato");
else if (selection == 5)
   WScript.Echo("You selected a Capucino");
else if (selection == 6)
   WScript.Echo("You selected a Mocha");
else if (selection == 7)
   WScript.Echo("You selected a Tea");
else
   WScript.Echo("You have not entered a valid selection");
