#!/usr/bin/env php
<?php
$nicknames = array("bob","ed","steve","ralph","joe","deb","kate");
echo "The names are: \n";
for ($count=0; $count < count($nicknames); $count++) {
    echo " nicknames[$count]=$nicknames[$count]\n";
}
?>