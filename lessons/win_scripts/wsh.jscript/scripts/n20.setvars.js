var drinks = {
   Capucino: 0,
   Coffee: 0,
   Espresso: 0,
   Latte: 0,
   Machiato: 0,
   Mocha: 0,
   Tea: 0
};

if (WScript.Arguments.length == 0) {
   for (var key in drinks) {
      drinks[key] = Math.floor(Math.random() * 3);
   }
} else {
   for (var i = 0; i < WScript.Arguments.length; i++) {
      var pair = WScript.Arguments(i).split(":");
      drinks[pair[0]] = parseInt(pair[1], 10);
   }
}

var keys = [];
for (var k in drinks) { keys.push(k); }
keys.sort();

var parts = [];
for (var j = 0; j < keys.length; j++) {
   if (drinks[keys[j]] != 0) {
      parts.push(keys[j] + ":" + drinks[keys[j]]);
   }
}
var order = parts.join(",");

// WScript.Shell's own "Process" environment block genuinely affects
//  this process (and anything it spawns), unlike some other
//  languages here where there's no supported way to modify a running
//  process's own environment at all.
var shell = WScript.CreateObject("WScript.Shell");
var processEnv = shell.Environment("Process");
processEnv("MY_ORDERS") = order;

var fso = WScript.CreateObject("Scripting.FileSystemObject");
var fh = fso.CreateTextFile("dump_env.out", true);
// Enumerator(processEnv)'s items are already whole "KEY=value" strings,
//  not bare keys needing a separate processEnv(name) lookup.
var e = new Enumerator(processEnv);
for (; !e.atEnd(); e.moveNext()) {
   fh.WriteLine(e.item());
}
fh.Close();

WScript.Echo("MY_ORDERS set, Hit Return to continue");
WScript.stdin.ReadLine();

fso.DeleteFile("dump_env.out");
