#!/usr/bin/env pash
# create empty hash
$ages = @{}
# individually build hash
$ages["bob"]=34
$ages["ed"]=58
$ages["steve"]=32
$ages["ralph"]=23
$ages["deb"]=46
$ages["kate"]=19
# print out results
"Keys  (names): " + $ages.keys    # print enumerated list of keys
"Values (ages): " + $ages.values  # print enumerated list of values
