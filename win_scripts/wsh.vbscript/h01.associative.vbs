' initialize dictionary object 
Set ages = CreateObject("Scripting.Dictionary")
' add one elment at a time to dictionary object
ages.Add "bob", 34
ages.Add "ed", 58
ages.Add "steve", 32
ages.Add "ralph", 23
ages.Add "deb", 46
ages.Add "kate", 19

' enumerate & print values
' NOTE: wscript.echo joins comma-separated arguments with its own space,
'  which was stacking with each literal's own trailing space inconsistently -
'  build the full string explicitly instead for exact control over spacing.
wscript.echo "Keys (names):  " & Join(ages.Keys, ", ")
wscript.echo "Values (ages): " & Join(ages.Items, ", ")
