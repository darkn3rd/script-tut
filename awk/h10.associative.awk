#!/bin/awk -f
BEGIN {
  # string with key:value pairs 
  some_ages = "bob:34 ed:58 steve:32 ralph:23"
  # create 1st associative array
  make_array(some_ages, ages)
  
  # second key:value string
  more_ages = "deb:46 kate:19"
  # create 2nd associative array 
  make_array(more_ages, ages_two)
  
  # merge two associative arrays
  merge(ages, ages_two)
  
  # iterate through associatve array, print key/value pairs
  print "The ages are: "
  for(name in ages)  
      printf " ages[\"%s\"] = %s\n", name, ages[name]
}

# Helper Functions as Awk has no method to 
#  create associative arrays in one line or 
#  merge two associative arrays

# **************************************
# make_array (scalar, array) - populates array given a string scalar
# **************************************
function make_array(strIn, arrOut)
{
  split(strIn, couplets)              # craft new array from key:value pairs
  
  for (i in couplets) {
    split(couplets[i], pair, ":")     # create mini-array of key and value
    
    # not the most efficient, but more illustrative
    name = pair[1]                    # save name 
    age  = pair[2]                    # save age
    
    # build the output associative array
    arrOut[name] = age
  }
}

# **************************************
# merge (array, array) - merges two arrays; left-most array is output
#   Warning: does not verify uniqueness of key index
# **************************************
function merge(arrIn, arrOut)
{  
  for (key in arrOut) arrIn[key] = arrOut[key] 
}
