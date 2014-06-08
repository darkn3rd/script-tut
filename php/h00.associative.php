#!/usr/bin/php
<?php
$ages[bob]=34;
$ages[ed]=58;
$ages[steve]=32;
$ages[ralph]=23;
$ages[deb]=46;
$ages[kate]=19;
 
echo "Keys (names): ", join(" ", (array_keys($ages))), "\n";
echo "Values (ages): ", join(" ", (array_values($ages))), "\n";
?>
