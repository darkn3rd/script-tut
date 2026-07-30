// initialize Array object
var ages = new Object();

// add one element at a time (using dot notation)
ages.bob   = 34;
ages.ed    = 58;
ages.steve = 32;
ages.ralph = 23;
ages.deb   = 46;
ages.kate  = 19;

// enumerate & print values
var keys = [];
for (var key in ages) keys.push(key);
WScript.stdout.write("Keys (names):  " + keys.join(", ") + "\n");

var values = [];
for (var key in ages) values.push(ages[key]);
WScript.stdout.write("Values (ages): " + values.join(", ") + "\n");
