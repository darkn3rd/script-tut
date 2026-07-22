#!/usr/bin/env pash
# create an empty list to force data type to be an array
$nicknames = @()
# populate array with each item
$nicknames += "bob"
$nicknames += "ed"
$nicknames += "steve"
$nicknames += "ralph"
$nicknames += "joe"
$nicknames += "deb"
$nicknames += "kate"
# output results
"The total nicknames are: " + $nicknames.length         # print size of array
"The nicknames are: " + ($nicknames -join ", ")         # print enumerated list
