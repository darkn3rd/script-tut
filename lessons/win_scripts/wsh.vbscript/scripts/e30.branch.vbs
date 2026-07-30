' VBScript has no heredoc/triple-quote syntax - a "&"-continued chain of
'  lines (continued with " _", joined with vbCrLf) is the closest stand-in
'  for a multi-line string literal, all held in one variable and printed
'  with a single call. The last line has no trailing vbCrLf - no
'  linebreak before the answer is typed.
menu = "Select an item from the menu." & vbCrLf & _
       "" & vbCrLf & _
       "  1 - Coffee" & vbCrLf & _
       "  2 - Espresso" & vbCrLf & _
       "  3 - Latte" & vbCrLf & _
       "  4 - Machiato" & vbCrLf & _
       "  5 - Capucino" & vbCrLf & _
       "  6 - Mocha" & vbCrLf & _
       "  7 - Tea" & vbCrLf & _
       "" & vbCrLf & _
       "Make your selection: "
wscript.stdout.write menu
selection = cint(wscript.stdin.readline)

if selection = 1 then
  wscript.echo "You selected a Coffee"
elseif selection = 2 then
  wscript.echo "You selected an Espresso"
elseif selection = 3 then
  wscript.echo "You selected a Latte"
elseif selection = 4 then
  wscript.echo "You selected a Machiato"
elseif selection = 5 then
  wscript.echo "You selected a Capucino"
elseif selection = 6 then
  wscript.echo "You selected a Mocha"
elseif selection = 7 then
  wscript.echo "You selected a Tea"
else
  wscript.echo "You have not entered a valid selection"
end if
