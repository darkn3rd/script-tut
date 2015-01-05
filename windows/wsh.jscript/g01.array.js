// create empty list
var nicknames = []

// resize array and insert element by index
nicknames[0] = "bob"
nicknames[1] = "ed"
nicknames[2] = "steve"
nicknames[3] = "ralph"
nicknames[4] = "joe"
nicknames[5] = "deb"
nicknames[6] = "kate"

WScript.echo("The total nicknames are: " + nicknames.length);
WScript.echo("The nicknames are: " + nicknames.join(", "));

/***********************************************
 * Array.join(sep) method - returns string given array and separator
 *  Helper method to help enumerate a list easily 
 ***********************************************/
 Array.prototype.join = function(sep)  {
    result = this[0]; // fetch 1st item from array

    for (i = 1; i < array.length; i++) 
        result += sep + this[i];  // append separator & array item
 
    return result;     // return result
 }
