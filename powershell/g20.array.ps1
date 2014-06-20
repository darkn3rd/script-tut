# build array using comma operator
$nicknames = "bob", "ed", "steve", "ralph", "joe", "deb", "kate"
# print results
"The names are: "
# enumberate array using count index
for ($count = 0; $count -lt $nicknames.length; $count++) { 
  " nicknames[$count] = " + $nicknames[$count] # print index and element
}
