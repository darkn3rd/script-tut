#!/usr/bin/env -S awk -f
BEGIN {
  # individually build array, tracking insertion order in a parallel
  #  array too since awk's "for (key in array)" iteration order is
  #  unspecified
  n = 0
  ages["bob"]=34;   key_order[++n] = "bob"
  ages["ed"]=58;    key_order[++n] = "ed"
  ages["steve"]=32; key_order[++n] = "steve"
  ages["ralph"]=23; key_order[++n] = "ralph"
  ages["deb"]=46;   key_order[++n] = "deb"
  ages["kate"]=19;  key_order[++n] = "kate"

  # print all key indexes
  print "Keys (names):  " keys(ages, key_order, n)

  # print all values
  print "Values (ages): " values(ages, key_order, n)
}

# ==================== HELPER FUNCTIONS ==================== #
# Helper Functions as Awk has no method to enumerate all values or keys
#   from an array in insertion order

# **************************************
# keys (array, order, count) - return comma-separated list of keys,
#  in the insertion order recorded in order[1..count]
# **************************************
function keys(array, order, count,    i, keyStr)
{
    keyStr = order[1]
    for (i = 2; i <= count; i++) keyStr = keyStr ", " order[i]

    return keyStr
}

# **************************************
# values (array, order, count) - return comma-separated list of values,
#  in the insertion order recorded in order[1..count]
# **************************************
function values(array, order, count,    i, valueStr)
{
    valueStr = array[order[1]]
    for (i = 2; i <= count; i++) valueStr = valueStr ", " array[order[i]]

    return valueStr
}
