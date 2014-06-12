#!/bin/awk -f
BEGIN {
  # individually build array
  ages["bob"]=34
  ages["ed"]=58
  ages["steve"]=32
  ages["ralph"]=23
  ages["deb"]=46
  ages["kate"]=19
 
  # print all key indexes
  print "Keys  (names): " values(ages)
 
  # print all values
  print "Values (ages): " keys(ages)
}

# Helper Functions as Awk has no method to 
#  enumerate all values or keys from an array

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
