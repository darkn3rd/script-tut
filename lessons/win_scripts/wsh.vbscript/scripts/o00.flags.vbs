usage = "" & vbCrLf & _
        "Usage: " & wscript.scriptname & " [-c|-e|-l|-k|-p|-m|-t] [-h|-?]" & vbCrLf & _
        "" & vbCrLf & _
        "  -c  Coffee" & vbCrLf & _
        "  -e  Espresso" & vbCrLf & _
        "  -l  Latte" & vbCrLf & _
        "  -k  Machiato" & vbCrLf & _
        "  -p  Capucino" & vbCrLf & _
        "  -m  Mocha" & vbCrLf & _
        "  -t  Tea" & vbCrLf & _
        "  -h  Display this help message" & vbCrLf & _
        "  -?  Display this help message" & vbCrLf & _
        "" & vbCrLf

if wscript.arguments.count = 1 then
  select case wscript.arguments(0)
    case "-c"
      wscript.echo "You ordered a Coffee."
      wscript.quit 0
    case "-e"
      wscript.echo "You ordered an Espresso."
      wscript.quit 0
    case "-l"
      wscript.echo "You ordered a Latte."
      wscript.quit 0
    case "-k"
      wscript.echo "You ordered a Machiato."
      wscript.quit 0
    case "-p"
      wscript.echo "You ordered a Capucino."
      wscript.quit 0
    case "-m"
      wscript.echo "You ordered a Mocha."
      wscript.quit 0
    case "-t"
      wscript.echo "You ordered a Tea."
      wscript.quit 0
    case "-h", "-?"
      wscript.stdout.write usage
      wscript.quit 0
  end select
end if

wscript.stderr.write usage
wscript.quit 1
