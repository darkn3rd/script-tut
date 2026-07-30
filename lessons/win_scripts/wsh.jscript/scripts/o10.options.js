var usage = "\n" +
            "Usage: " + WScript.ScriptName + " [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]\n" +
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

var flags = {
   "-c": "coffee",
   "-e": "espresso",
   "-l": "latte",
   "-k": "macchiato",
   "-p": "capucino",
   "-m": "mocha",
   "-t": "tea"
};

var orders = [];
for (var i = 0; i < WScript.Arguments.length; i++) {
   var arg = WScript.Arguments(i);
   if (arg == "-h" || arg == "-?") {
      WScript.stdout.write(usage);
      WScript.Quit(0);
   } else if (flags.hasOwnProperty(arg)) {
      orders.push(flags[arg]);
   }
}

if (orders.length == 0) {
   WScript.stderr.write(usage);
   WScript.Quit(1);
}

WScript.Echo("");
WScript.Echo("You ordered: ");
for (var j = 0; j < orders.length; j++) {
   WScript.Echo("* " + orders[j]);
}
