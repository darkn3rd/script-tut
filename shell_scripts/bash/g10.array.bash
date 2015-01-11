#!/usr/bin/env bash
declare -a nicknames=(bob ed steve ralph joe deb kate)

echo "The names are: "
for name in ${nicknames[*]}; do
  echo "  $name"
done
