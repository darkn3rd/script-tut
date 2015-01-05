' create populated list
nicknames = Array("bob","ed","steve","ralph","joe","deb","kate")

' output results
WScript.Echo "The names are: "
' collection loop get each element
For Each name In nicknames
    wscript.echo " " & name
Next
