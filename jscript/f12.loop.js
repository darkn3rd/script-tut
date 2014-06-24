var sequence = range(10,1)  // generate sequence

// count style for..in and custom range helper function
for (count in sequence) {
  WScript.echo("Count is " + sequence[count]); // output counter
}

/***************************************
 * range (start,finish) - generate a sequence of numbers between start and finish.
 *   Helper function as JScript doesn't have range function or operator to generate
 *   sequence of numbers.  
 *************************************** */
function range (start,finish) {
  var sequence = new Array;      // create new dynamic array on heap
  
  if (start < finish) {
    last = finish - start
	for (var index = 0, count = start; index <= last; index++, count++) {
	  sequence[index] = count;
	}
  } 
  else if (start > finish) {
    last = start - finish;
    for (var index = 0, count = start; index <= last; index++, count--) { 
	  sequence[index] = count;
	}
  } 
  else {
    // must be equal to each other
    sequence[0] = start;
  }

  return sequence;          // return Array (which is really JScript hash) 
}
