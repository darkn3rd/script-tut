#!/usr/bin/php
<?php
// initialize array with key/value pairs
$ages = array("bob"=>34, "ed"=>58, "steve"=>32, "ralph"=>23);
// append another set of key/value pairs into array
$ages = array_merge($ages, array("deb"=>46, "kate"=>19));
 
print "The ages are: \n";
foreach (array_keys($ages) as $name) {
    echo " ages[$name]=$ages[$name]\n";
}
?>
