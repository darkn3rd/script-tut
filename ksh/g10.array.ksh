#!/bin/ksh
set -A nicknames bob ed steve ralph joe deb kate
 
print "The names are: "

# use collection loop to get items in array
for name in ${nicknames[*]}; do
  print " $name"
done
