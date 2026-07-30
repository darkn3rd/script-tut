#!/usr/bin/env bash
# declare and initialize empty associative array
declare -A ages

# add key/value pair one by one
ages[bob]=34
ages[ed]=58
ages[steve]=32
ages[ralph]=23
ages[deb]=46
ages[kate]=19

# print all keys and values
keys=$(printf ", %s" "${!ages[@]}")   # join with ", " separator
values=$(printf ", %s" "${ages[@]}")  # join with ", " separator
echo "Keys (names):  ${keys:2}"
echo "Values (ages): ${values:2}"
