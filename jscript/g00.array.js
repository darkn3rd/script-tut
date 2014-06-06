// create empty list
var nicknames = new Array()
// resize array and insert element by index
nicknames[0] = "bob"
nicknames[1] = "ed"
nicknames[2] = "steve"
nicknames[3] = "ralph"
nicknames[4] = "joe"
nicknames[5] = "deb"
nicknames[6] = "kate"

WScript.echo("The total nicknames are: " + nicknames.length);
WScript.stdout.write("The nicknames are: ");
for (var index in nicknames) { 
  if (index == nicknames.length - 1) 
    WScript.Echo(nicknames[index]);
  else 
    WScript.stdout.write(nicknames[index] + ", ");
}
