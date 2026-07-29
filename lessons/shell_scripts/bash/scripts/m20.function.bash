#!/usr/bin/env bash

# create function (subroutine)
function sort_array {
  printf "%s\n" "$@" | sort # print sorted elements, one per line
}

# initialize initial array
array=(bob ed steve ralph joe deb kate)
joined=$(printf ", %s" "${array[@]}")
echo "Current names are: ${joined:2}"

# call function in subshell, capture lines back into a new array
result=($(sort_array "${array[@]}"))

# output the result
joined=$(printf ", %s" "${result[@]}")
echo "Sorted names are: ${joined:2}"
