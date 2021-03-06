#!/usr/bin/env pash
# create the function
Function Sort-Array ($array) {
    $array | Sort-Object # return list
}

# initialize initial array (list)
$array = "bob", "ed", "steve", "ralph", "joe", "deb", "kate"

# output current list before calling function
"Current names are: $($array -join ", ")"

# call the function
$result = Sort-Array $array

# output the result
"Sorted names are: $($result -join ", ")"
