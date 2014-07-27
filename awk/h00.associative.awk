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
  print "Keys  (names): " keys(ages)
 
  # print all values
  print "Values (ages): " values(ages)
}

# Helper Functions as Awk has no method to 
#  enumerate all values or keys from an array


# **************************************
# keys (array) - return list of keys as string
#  keys may be completely out of order
# **************************************
function keys(array)
{
    keyStr = ""
     
    for (key in ages) keyStr = keyStr " " key
 
    return keyStr
}

# **************************************
# values (array) - return list of values as string
#  values may be completely out of order
# **************************************
function values(array)
{
    valueStr = ""
     
    for (key in ages) valueStr = valueStr " " ages[key]
 
    return valueStr
}
