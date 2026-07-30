var usage = "\n" +
            "Usage: " + WScript.ScriptName + " [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]\n" +
            "\n" +
            "  --coffee,    -c N  Coffee\n" +
            "  --espresso,  -e N  Espresso\n" +
            "  --latte,     -l N  Latte\n" +
            "  --macchiato, -k N  Machiato\n" +
            "  --capucino,  -p N  Capucino\n" +
            "  --mocha,     -m N  Mocha\n" +
            "  --tea,       -t N  Tea\n" +
            "  --help,      -h    Display this help message\n" +
            "  -?                 Display this help message\n" +
            "\n";

var flags = {
   "--coffee": "coffee", "-c": "coffee",
   "--espresso": "espresso", "-e": "espresso",
   "--latte": "latte", "-l": "latte",
   "--macchiato": "macchiato", "-k": "macchiato",
   "--capucino": "capucino", "-p": "capucino",
   "--mocha": "mocha", "-m": "mocha",
   "--tea": "tea", "-t": "tea"
};

var orders = [];
var i = 0;
while (i < WScript.Arguments.length) {
   var arg = WScript.Arguments(i);
   if (arg == "-h" || arg == "-?" || arg == "--help") {
      WScript.stdout.write(usage);
      WScript.Quit(0);
   } else if (flags.hasOwnProperty(arg)) {
      var name = flags[arg];
      var n = parseInt(WScript.Arguments(i + 1), 10);
      var suffix = (n == 1) ? "" : "s";
      orders.push(n + " " + name + suffix);
      i += 2;
   } else {
      WScript.stderr.write(usage);
      WScript.Quit(1);
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
