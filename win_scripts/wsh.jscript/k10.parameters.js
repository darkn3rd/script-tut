// create subroutine
function addNums() 
{
  var numbers = [].slice.call(arguments);
  var sum = 0;

  for (var num in numbers)
    sum += numbers[num];

  WScript.echo("The summation is " + sum + ".");  // output result
}

// call the subroutine 
addNums(5, 2, 4, 3, 6)
