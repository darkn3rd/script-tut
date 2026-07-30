#!/usr/bin/env tcsh
# Unlike sh/bash, tcsh has no way to hold a literal multi-line string in
#  a scalar variable: a quoted string can't span physical lines (even
#  with backslash-continuation), and capturing a heredoc via backticks
#  into a variable collapses its newlines into single spaces (tcsh
#  variables are word-lists under the hood). A direct heredoc - the same
#  technique as a21.output.csh - is the closest tcsh equivalent, printed
#  straight to stdout instead of stored in a "menu" variable; the final
#  prompt (which must have no trailing newline) is a separate echo -n.
cat << EOF
Select an item from the menu.

  1 - Coffee
  2 - Espresso
  3 - Latte
  4 - Machiato
  5 - Capucino
  6 - Mocha
  7 - Tea

EOF
echo -n "Make your selection: " # print prompt & acquire input
set selection=$<              # acquire input

if ( $selection == 1 ) then
  echo "You selected a Coffee"
else if ( $selection == 2 ) then
  echo "You selected an Espresso"
else if ( $selection == 3 ) then
  echo "You selected a Latte"
else if ( $selection == 4 ) then
  echo "You selected a Machiato"
else if ( $selection == 5 ) then
  echo "You selected a Capucino"
else if ( $selection == 6 ) then
  echo "You selected a Mocha"
else if ( $selection == 7 ) then
  echo "You selected a Tea"
else
  echo "You have not entered a valid selection"
endif
# ^ newline required or failure
