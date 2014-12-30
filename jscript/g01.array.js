// create empty list
var nicknames = new Array()

// resize array and insert element by index
nicknames.0 = "bob"
nicknames.1 = "ed"
nicknames.2 = "steve"
nicknames.3 = "ralph"
nicknames.4 = "joe"
nicknames.5 = "deb"
nicknames.6 = "kate"

WScript.echo("The total nicknames are: " + nicknames.length);
WScript.echo("The nicknames are: " + join(nicknames, ", "));

/***********************************************
 * Join (array, sep) - returns string given array and seperator
 *  Helper function to help enumerate a list easily
 ***********************************************/
function join(array, sep)
{
    result = array.0; // fetch 1st item from array

    for (i = 0; i < array.length; i++)
        result += sep + array.i;  // append seperator & array item

    return result;     // return result
}
