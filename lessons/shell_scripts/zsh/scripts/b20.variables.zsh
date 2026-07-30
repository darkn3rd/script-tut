#!/usr/bin/env zsh
# declare variables
declare -i num=10/2        # explicitly set an integer
char=a                     # set a character
string="This is a string"  # set a string

# show the results using formatting
# a single quote needs no escaping inside a double-quoted string - zsh's
#  printf, unlike bash's, doesn't silently swallow a stray backslash
#  before an already-unspecial character, so \' would print literally
printf "Number is %d.\n" $num
printf "Character is '%c'.\n" $char
printf "String is \"%s\".\n" "$string"
