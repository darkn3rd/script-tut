' create populated list
nicknames = array("bob","ed","steve","ralph","joe","deb","kate")
' iterate through array by each item
wscript.echo "The names are: "
for each name in nicknames
    wscript.echo " " & name
next
