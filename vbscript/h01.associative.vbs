' initialize COM object 
set ages = CreateObject("Scripting.Dictionary")
' add one elment at a time
ages.add "bob", 34
ages.add "ed", 58
ages.add "steve", 32
ages.add "ralph", 23
ages.add "deb", 46
ages.add "kate", 19
' enumerate & print values
wscript.echo "Keys (names): ", join(ages.keys, " ")
wscript.echo "Values (ages): ", join(ages.items, " ")
