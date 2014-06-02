# build array using comma operator
$nicknames = "bob", "ed", "steve", "ralph", "joe", "deb", "kate"
# print results
"The names are: "
foreach ($name in $nicknames) {   # cycle through array
  " $name"                        # print out each element
}
