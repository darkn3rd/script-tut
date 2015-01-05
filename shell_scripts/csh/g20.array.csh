#!/usr/bin/env tcsh

# build aray in one line
set nicknames = (bob ed steve ralph joe deb kate)
set end = $#nicknames

# print out array item by item
echo The names are: 
foreach count (`seq 1 $end`) 
  echo "  nicknames[$count] = $nicknames[$count]"
end
