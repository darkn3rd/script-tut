' create populated list
nicknames = array("bob","ed","steve","ralph","joe","deb","kate")

' output array
wscript.echo "The names are: "
' count loop to create count index
for count = 0 to ubound(nicknames)
    wscript.echo " nicknames[" & count & "]=" & nicknames(count)
next
