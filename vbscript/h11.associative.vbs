' populate initial dictionary
set ages = dictionary(array("bob", 34, "ed", 58, "steve", 32, "ralph", 23))
' append more items into dictionary
set ages = merge(ages, dictionary(array("deb", 46, "kate", 19)))
' iterate through dictionary, print key/value pairs
wscript.echo "The ages are: "
for each name in ages.keys  
    wscript.echo " ages[" & name & "]=" & ages.item(name)
next

' dictionary() - creates dictionary given array
function dictionary (items)
  ' create empty dictionary
  set dictionary = CreateObject("Scripting.Dictionary")

  ' iterate through array to create dictionary
  for i=lbound(items) to ubound(items) step 2
    dictionary.add items(i), items(i+1)
  next
end function

' merge() - merges two dictionaries together
function merge (left, right)
  ' create empty dictionary
  set merge = CreateObject("Scripting.Dictionary")

  ' iterate through left dictionary
  for each key in left.keys  
    merge.add key, left(key)
  next

  ' iterate through right dictionary
  for each key in right.keys  
    merge.add key, right(key)
  next
end function