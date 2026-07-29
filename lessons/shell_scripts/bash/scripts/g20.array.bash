#!/usr/bin/env bash
 
declare -a nicknames=(bob ed steve ralph joe deb kate)
 
echo "The names are: "
for (( count=0; count < ${#nicknames[*]}; count++ )); do
  echo " nicknames[$count]=${nicknames[$count]}"
done
