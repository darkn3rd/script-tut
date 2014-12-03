#!/usr/bin/node

// create subroutine
function show_date() 
{
  var today  = new Date();
  var months = ['January', 'February', 'March', 'April', 
                'May', 'June', 'July', 'August', 
                'September', 'October', 'November', 'December'];

  // create formatted date parts
  B = months[today.getMonth()];   // Use Lookup array
  d = today.getDate();
  Y = today.getFullYear();

  // output result 
  console.log("Today is " + B + " " + d + ", " + Y + "."); 
}

// call the subroutine 
show_date();
