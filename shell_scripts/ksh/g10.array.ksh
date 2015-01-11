#!/usr/bin/env ksh
# declare and initilize array on one line
set -A nicknames bob ed steve ralph joe deb kate
# output the results of array
print "The names are: "
# use collection loop to get items in array
for name in ${nicknames[*]}; do
  print "  $name"
done
