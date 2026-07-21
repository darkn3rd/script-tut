#!/usr/bin/env php
<?php
// create function
function capitalize($string) {
	return strtoupper($string); // return capitlized string
}

// output string before calling function
$string = "ibm";
echo "The current string is: \"$string\".\n";

// call the function
$result = capitalize($string);  // pass string

# output results after calling function
echo "The capitalized string is: \"$result\".\n";
?>