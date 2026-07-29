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
  # Note: awk has no mechanism to enumerate all keys,
  #   so we must loop through array
  printf "Keys  (names): "
  for (key in ages) printf key " "
  printf "\n"
 
 
  # print all values
  # Note: awk has no mechanism to enumerate all values,
  #   so we must loop through array
  printf "Values (ages): "
  for (key in ages) printf ages[key] " "
  printf "\n"
}
