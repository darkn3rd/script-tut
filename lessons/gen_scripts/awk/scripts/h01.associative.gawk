#!/usr/bin/env -S gawk -f
# testbox: title="PROCINFO sorted_in - gawk-only deterministic order"
# Requirements: gawk (PROCINFO["sorted_in"] is a GNU extension; a plain
#  POSIX awk treats PROCINFO as an ordinary array and ignores it silently
#  - see h00.associative.awk for the portable key_order-tracking version)
BEGIN {
  # individually build array
  ages["bob"]=34
  ages["ed"]=58
  ages["steve"]=32
  ages["ralph"]=23
  ages["deb"]=46
  ages["kate"]=19

  # gawk-only: control "for (key in array)" traversal order natively
  #  instead of hand-tracking insertion order in a parallel array
  PROCINFO["sorted_in"] = "@ind_str_asc"

  keysStr = ""; valsStr = ""
  for (key in ages) {
    keysStr = (keysStr == "") ? key : keysStr ", " key
    valsStr = (valsStr == "") ? ages[key] : valsStr ", " ages[key]
  }

  # print all key indexes
  print "Keys (names):  " keysStr

  # print all values
  print "Values (ages): " valsStr
}
