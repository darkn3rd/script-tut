// initialize COM object 
var ages = new Array(); 

// add one elment at a time
ages["bob"]   = 34;
ages["ed"]    = 58;
ages["steve"] = 32;
ages["ralph"] = 23;
ages["deb"]   = 46;
ages["kate"]  = 19;

// enumerate & print values
WScript.stdout.write("Keys (names):  ");
for (var key in ages) WScript.stdout.write(key + " "); 
WScript.echo(" ");
WScript.stdout.write("Values (ages): "); 
for (var key in ages) WScript.stdout.write(ages[key] + " ");
