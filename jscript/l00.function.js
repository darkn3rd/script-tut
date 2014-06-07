// create the function
function addNums(numbers) {
  var sum = 0;

  for (var num in numbers)
    sum += numbers[num];

  return sum;
}

// call the function
result = addNums([5,2,4,3,6])

// output rersults
WScript.echo("The result of summation is: " + result + ".");
