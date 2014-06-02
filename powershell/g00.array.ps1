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
"The number of nicknames is: " + $nicknames.length  # print size of array
"The nicknames are: $nicknames"                     # print enumerated list
