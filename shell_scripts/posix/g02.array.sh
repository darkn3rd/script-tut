#!/usr/bin/env sh
# created populated list using space-delimited string
nicknames="bob ed steve ralph joe deb kate"

# print length of list
total=$(echo $nicknames | awk '{ print NF }')
echo "The total nicknames are: $total"

# iterate through string with for/in/do..done construction
joined=""
for name in $nicknames; do
  joined="$joined, $name"
done
joined=${joined#, }
printf "The nicknames are: %s\n" "$joined"
