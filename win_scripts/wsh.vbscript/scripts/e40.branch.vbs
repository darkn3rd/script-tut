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

select case selection
  case 1
    wscript.echo "You selected a Coffee"
  case 2
    wscript.echo "You selected an Espresso"
  case 3
    wscript.echo "You selected a Latte"
  case 4
    wscript.echo "You selected a Machiato"
  case 5
    wscript.echo "You selected a Capucino"
  case 6
    wscript.echo "You selected a Mocha"
  case 7
    wscript.echo "You selected a Tea"
  case else
    wscript.echo "You have not entered a valid selection"
end select
