#!/bin/awk -f
BEGIN {
  numbers = array("5 4 6 2 3 3")
}

# **************************************
# array (string) - given a string, makes an array 
# **************************************
function array(s)
{
   split(s, a)
   return a 
} 
