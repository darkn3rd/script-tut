// create populated list
nicknames = ["bob","ed","steve","ralph","joe","deb","kate"];
// iterate through array by each item
WScript.echo("The names are: ");
for (var index in nicknames)
    WScript.echo(" " + nicknames[index]);
