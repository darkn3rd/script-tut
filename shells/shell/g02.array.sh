#!/usr/bin/env sh
# created populated list using space-delimited string
nicknames="bob ed steve ralph joe deb kate"
 
# print length of list
total=$(echo $nicknames | awk '{ print NF }')
echo "Total nicknames is (using awk): $total"
 
# iterate through string with for/in/do..done construction
echo "The names are: "
for name in $nicknames; do
  echo " $name"
done