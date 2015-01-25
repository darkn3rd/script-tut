// populate initial associative Array
var ages = {"bob":34, "ed":58, "steve":32, "ralph":23};

// append more items into associative Array
ages = merge(ages, {"deb":46, "kate":19});

// iterate through dictionary, print key/value pairs
WScript.Echo("The ages are: ")
for(var name in ages)
    WScript.Echo("  ages[" + name + "]=" + ages[name]);

// merge() - merges two associative arrays (objects)
function merge(a, b)
{
  for (key in b)
    a[key] = b[key];
  return a;
}
