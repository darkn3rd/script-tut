#!/bin/awk -f
BEGIN {
  # build a string that represents key:value pairings 
  agesStr = "bob:34 ed:58 steve:32 ralph:23 deb:46 kate:19"
  
  # create the array as store it as ages
  make_array(agesStr, ages)
  
  # print all key indexes
  print "Keys  (names): " values(ages)
 
  # print all values
  print "Values (ages): " keys(ages)
}

# Helper Functions as Awk has no method to 
#  enumerate all values or keys from an array

# **************************************
# make_array (scalar, array) - populates array given a string scalar
# **************************************
function make_array(strIn, arrOut)
{
  split(strIn, couplets)              # craft new array from key:value pairs
  for (i in couplets) {
        split(couplets[i], pair, ":") # create mini-array of key and value
    
    # not the most efficient, but more illustrative
    name = pair[1]                    # save name 
    age = pair[2]                     # save age
    
    # build the output associative array
    arrOut[name] = age
  }
}

# **************************************
# values (array) - return list of values as string
#  values may be completely out of order
# **************************************
function values(array)
{
    keyStr = ""
     
    for (key in ages) keyStr = keyStr " " key
 
    return keyStr
}

# **************************************
# keys (array) - return list of keys as string
#  keys may be completely out of order
# **************************************
function keys(array)
{
    keyStr = ""
     
    for (key in ages) keyStr = keyStr " " ages[key]
 
    return keyStr
}
