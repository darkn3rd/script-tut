#!/usr/bin/env bash
printf "%s" "Input a character: " # print prompt
read -n 1 character                # read exactly one character, no Enter needed
printf "You entered: >>|%s|<<.\n" "$character"
