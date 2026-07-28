#!/usr/bin/env zsh
printf "%s" "Input a character: " # print prompt
# zsh's "-n" is a completion-context flag (only meaningful with -c/-l), not
#  bash's "read this many characters" - the single-char equivalent is "-k",
#  but "-k" alone insists on opening the real terminal even when stdin is a
#  pipe; "-u 0" makes it read from fd 0 (stdin) instead, which works both
#  piped and at a live terminal
read -k 1 -u 0 character           # read exactly one character, no Enter needed
printf "You entered: >>|%s|<<.\n" "$character"
