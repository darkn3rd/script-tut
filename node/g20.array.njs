#!/usr/bin/node

// create populated list
nicknames = new Array("bob","ed","steve","ralph","joe","deb","kate");
// iterate array elements by index
console.log("The names are: ");
for(count = 0; count < nicknames.length; count++)
    console.log(" nicknames[" + count + "]=" + nicknames[count]);
