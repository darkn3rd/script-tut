#!/usr/bin/node

// populate initial associative Array
var ages = {"bob":34, "ed":58, "steve":32, "ralph":23};

// append more items into associative Array
ages = merge(ages, {"deb":46, "kate":19});

// iterate through dictionary, print key/value pairs
console.log("The ages are: ")
for(var name in ages)  
    console.log(" ages[" + name + "]=" + ages[name]);

// merge() - merges two arrays 
function merge(array1, array2) 
{
  for (key in array1) 
    array2[key] = array1[key];
  return array2;
}
