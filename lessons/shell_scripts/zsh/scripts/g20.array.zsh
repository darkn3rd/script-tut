#!/usr/bin/env zsh
# zsh arrays are 1-indexed by default, so ${nicknames[$count]} below would
#  be off by one against a count starting at 0 - this option makes array
#  subscripts behave like ksh/bash (0-indexed) instead
setopt KSH_ARRAYS

declare -a nicknames=(bob ed steve ralph joe deb kate)
 
echo "The names are: "
for (( count=0; count < ${#nicknames[*]}; count++ )); do
  echo " nicknames[$count]=${nicknames[$count]}"
done
