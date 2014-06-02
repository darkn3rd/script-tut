# build array using comma operator
$nicknames = "bob", "ed", "steve", "ralph", "joe", "deb", "kate"
# print results
"The names are: "
for ($count = 0; $count -lt $nicknames.length; $count++) { # iterate by index
  " nicknames[$count] = " + $nicknames[$count]             # print index and element
}
