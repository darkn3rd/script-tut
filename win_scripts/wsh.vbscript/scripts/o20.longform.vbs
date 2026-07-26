usage = "" & vbCrLf & _
        "Usage: " & wscript.scriptname & " [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]" & vbCrLf & _
        "" & vbCrLf & _
        "  --coffee,    -c N  Coffee" & vbCrLf & _
        "  --espresso,  -e N  Espresso" & vbCrLf & _
        "  --latte,     -l N  Latte" & vbCrLf & _
        "  --macchiato, -k N  Machiato" & vbCrLf & _
        "  --capucino,  -p N  Capucino" & vbCrLf & _
        "  --mocha,     -m N  Mocha" & vbCrLf & _
        "  --tea,       -t N  Tea" & vbCrLf & _
        "  --help,      -h    Display this help message" & vbCrLf & _
        "  -?                 Display this help message" & vbCrLf & _
        "" & vbCrLf

dim names(20)
dim counts(20)
count = 0

i = 0
do while i < wscript.arguments.count
  arg = wscript.arguments(i)
  select case arg
    case "-h", "-?", "--help"
      wscript.stdout.write usage
      wscript.quit 0
    case "--coffee", "-c"
      names(count) = "coffee"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case "--espresso", "-e"
      names(count) = "espresso"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case "--latte", "-l"
      names(count) = "latte"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case "--macchiato", "-k"
      names(count) = "macchiato"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case "--capucino", "-p"
      names(count) = "capucino"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case "--mocha", "-m"
      names(count) = "mocha"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case "--tea", "-t"
      names(count) = "tea"
      counts(count) = wscript.arguments(i + 1)
      count = count + 1
      i = i + 2
    case else
      wscript.stderr.write usage
      wscript.quit 1
  end select
loop

if count = 0 then
  wscript.stderr.write usage
  wscript.quit 1
end if

wscript.echo ""
wscript.echo "You ordered: "
for i = 0 to count - 1
  suffix = ""
  if counts(i) <> "1" then suffix = "s"
  wscript.echo "* " & counts(i) & " " & names(i) & suffix
next
