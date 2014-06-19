#!/usr/bin/node

// create populated list
nicknames = new Array("bob","ed","steve","ralph","joe","deb","kate");
// iterate through array by each item
console.log("The names are: ");
for (var index in nicknames)
    console.log(" " + nicknames[index]);
