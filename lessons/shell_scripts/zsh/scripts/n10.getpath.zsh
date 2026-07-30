#!/usr/bin/env zsh
# Split $PATH on its OS-native delimiter and print each entry on its own
#  line. A given PATH value never mixes both delimiters, so checking for
#  a semicolon first is enough to tell which one actually applies -
#  splitting a Windows-style "C:\Windows;C:\Users" on ":" would otherwise
#  cut every entry in half at its own drive letter.
# zsh's read uses "-A" (uppercase) for "split into this array name" -
#  bash's lowercase "-a" is a bad option here
if [[ "$PATH" == *";"* ]]; then
  IFS=';' read -rA dirs <<< "$PATH"
else
  IFS=':' read -rA dirs <<< "$PATH"
fi

for dir in "${dirs[@]}"; do
  echo "$dir"
done
