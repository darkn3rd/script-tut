#!/usr/bin/env php
<?php
$nicknames[0] = "bob";
$nicknames[1] = "ed";
$nicknames[2] = "steve";
$nicknames[3] = "ralph";
$nicknames[4] = "joe";
$nicknames[5] = "deb";
$nicknames[6] = "kate";

echo "The total nicknames are: ", count($nicknames), "\n";
echo "The nicknames are: ", implode(" ", $nicknames), "\n";
?>
