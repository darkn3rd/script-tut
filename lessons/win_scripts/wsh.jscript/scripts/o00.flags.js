var usage = "\n" +
            "Usage: " + WScript.ScriptName + " [-c|-e|-l|-k|-p|-m|-t] [-h|-?]\n" +
            "\n" +
            "  -c  Coffee\n" +
            "  -e  Espresso\n" +
            "  -l  Latte\n" +
            "  -k  Machiato\n" +
            "  -p  Capucino\n" +
            "  -m  Mocha\n" +
            "  -t  Tea\n" +
            "  -h  Display this help message\n" +
            "  -?  Display this help message\n" +
            "\n";

if (WScript.Arguments.length == 1) {
   var flag = WScript.Arguments(0);
   switch (flag) {
      case "-c": WScript.Echo("You ordered a Coffee."); WScript.Quit(0);
      case "-e": WScript.Echo("You ordered an Espresso."); WScript.Quit(0);
      case "-l": WScript.Echo("You ordered a Latte."); WScript.Quit(0);
      case "-k": WScript.Echo("You ordered a Machiato."); WScript.Quit(0);
      case "-p": WScript.Echo("You ordered a Capucino."); WScript.Quit(0);
      case "-m": WScript.Echo("You ordered a Mocha."); WScript.Quit(0);
      case "-t": WScript.Echo("You ordered a Tea."); WScript.Quit(0);
      case "-h":
      case "-?":
         WScript.stdout.write(usage);
         WScript.Quit(0);
   }
}

WScript.stderr.write(usage);
WScript.Quit(1);
