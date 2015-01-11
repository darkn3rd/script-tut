#!/usr/bin/env sh
# created populated list using space-delimited string
nicknames="bob ed steve ralph joe deb kate"

# print length of list
total=$(echo $nicknames | wc -w | tr -d " ")
echo "The number of nicknames is $total"

# iterate through string with for/in/do..done construction
printf "The nicknames are:"
for name in $nicknames; do
  printf " $name"
done
printf "\n"
