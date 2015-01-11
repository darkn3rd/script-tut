#!/usr/bin/env tcsh

# build aray in one line
set nicknames = (bob ed steve ralph joe deb kate)

# print out array item by item
echo "The names are: " 
foreach name ($nicknames)
  echo "  $name"
end
