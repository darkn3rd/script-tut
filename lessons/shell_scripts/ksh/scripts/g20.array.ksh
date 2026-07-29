#!/usr/bin/env ksh
 
set -A nicknames bob ed steve ralph joe deb kate
count=0
 
print "The names are: "

# use conditional loop with counter to get items in array
while [[ $count -lt ${#nicknames[*]} ]] ; do
  print " nicknames[$count]=${nicknames[$count]}"
  count=$(($count+1))
done
