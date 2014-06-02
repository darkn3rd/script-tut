' create populated list
nicknames = array("bob","ed","steve","ralph","joe","deb","kate")
' iterate array elements by index
wscript.echo "The names are: "
for count = 0 to ubound(nicknames)
    wscript.echo " nicknames[" & count & "]=" & nicknames(count)
next
