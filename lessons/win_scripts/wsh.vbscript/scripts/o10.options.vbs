usage = "" & vbCrLf & _
        "Usage: " & wscript.scriptname & " [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]" & vbCrLf & _
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

dim orders()
redim orders(wscript.arguments.count)
count = 0

for i = 0 to wscript.arguments.count - 1
  arg = wscript.arguments(i)
  select case arg
    case "-h", "-?"
      wscript.stdout.write usage
      wscript.quit 0
    case "-c"
      orders(count) = "coffee"
      count = count + 1
    case "-e"
      orders(count) = "espresso"
      count = count + 1
    case "-l"
      orders(count) = "latte"
      count = count + 1
    case "-k"
      orders(count) = "macchiato"
      count = count + 1
    case "-p"
      orders(count) = "capucino"
      count = count + 1
    case "-m"
      orders(count) = "mocha"
      count = count + 1
    case "-t"
      orders(count) = "tea"
      count = count + 1
  end select
next

if count = 0 then
  wscript.stderr.write usage
  wscript.quit 1
end if

wscript.echo ""
wscript.echo "You ordered: "
for i = 0 to count - 1
  wscript.echo "* " & orders(i)
next
