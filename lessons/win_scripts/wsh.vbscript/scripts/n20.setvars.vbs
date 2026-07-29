dim drinkNames(6)
drinkNames(0) = "Capucino"
drinkNames(1) = "Coffee"
drinkNames(2) = "Espresso"
drinkNames(3) = "Latte"
drinkNames(4) = "Machiato"
drinkNames(5) = "Mocha"
drinkNames(6) = "Tea"

dim drinks()
redim drinks(6)
for i = 0 to 6
  drinks(i) = 0
next

if wscript.arguments.count = 0 then
  randomize
  for i = 0 to 6
    drinks(i) = int(rnd * 3)
  next
else
  for a = 0 to wscript.arguments.count - 1
    pair = wscript.arguments(a)
    colonPos = instr(pair, ":")
    key = left(pair, colonPos - 1)
    qty = mid(pair, colonPos + 1)
    for i = 0 to 6
      if drinkNames(i) = key then
        drinks(i) = cint(qty)
      end if
    next
  next
end if

' drinkNames is already alphabetically ordered above, so no separate
' sort step is needed.
order = ""
for i = 0 to 6
  if drinks(i) <> 0 then
    if order = "" then
      order = drinkNames(i) & ":" & drinks(i)
    else
      order = order & "," & drinkNames(i) & ":" & drinks(i)
    end if
  end if
next

' WScript.Shell's own "Process" environment block genuinely affects
' this process (and anything it spawns), unlike some other languages
' here where there's no supported way to modify a running process's
' own environment at all.
set shell = wscript.createobject("WScript.Shell")
set processEnv = shell.Environment("Process")
processEnv("MY_ORDERS") = order

set fso = wscript.createobject("Scripting.FileSystemObject")
set fh = fso.CreateTextFile("dump_env.out", true)
' Enumerator items here are already whole "KEY=value" strings, not
' bare keys needing a separate processEnv(name) lookup.
for each item in processEnv
  fh.WriteLine item
next
fh.Close

wscript.echo "MY_ORDERS set, Hit Return to continue"
wscript.stdin.readline

fso.DeleteFile "dump_env.out"
