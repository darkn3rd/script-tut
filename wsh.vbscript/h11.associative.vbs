' populate initial dictionary
Set ages = dictionary(Array("bob", 34, "ed", 58, "steve", 32, "ralph", 23))

' append more items into dictionary
Set ages = merge(ages, dictionary(Array("deb", 46, "kate", 19)))

' output results with key/value pairs
WScript.Echo "The ages are: "
' collection loop used to fetch each key
For Each name In ages.Keys
    WScript.Echo " ages[" & name & "]=" & ages.Item(name)
next


' **************************************
' dictionary (items) - given array of key/value pairs,
'  creates a dictionary object
' **************************************
Function dictionary (items)
  ' create empty dictionary
  set dictionary = CreateObject("Scripting.Dictionary")

  ' iterate through array to create dictionary
  For i=LBound(items) To UBound(items) Step 2
    dictionary.Add items(i), items(i+1)
  Next
End Function

' **************************************
' merge (left, right) - given two dictionary objects
'   creates new dictionary with contents of both
' **************************************
Function merge (dictOne, dictTwo)
  ' create empty dictionary
  Set merge = CreateObject("Scripting.Dictionary")

  ' iterate through left dictionary
  For Each key In dictOne.Keys  
    merge.Add key, dictOne(key)
  Next

  ' iterate through right dictionary
  For Each key In dictTwo.Keys
    merge.Add key, dictTwo(key)
  Next
End Function