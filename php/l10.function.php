#!/usr/bin/php
<?php
// create function
function capitalize($string) {
	return strtoupper($string); // return capitlized string
}

// call the function
$result = capitalize("ibm");    // pass string 

# output results with resulting integer
echo "The result of capitalization is: $result.\n";
?>