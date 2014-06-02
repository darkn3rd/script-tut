' create empty list
dim nicknames()
' resize array and insert element by index
redim preserve nicknames(1) : nicknames(0) = "bob"
redim preserve nicknames(2) : nicknames(1) = "ed"
redim preserve nicknames(3) : nicknames(2) = "steve"
redim preserve nicknames(4) : nicknames(3) = "ralph"
redim preserve nicknames(5) : nicknames(4) = "joe"
redim preserve nicknames(6) : nicknames(5) = "deb"
redim preserve nicknames(7) : nicknames(6) = "kate"

wscript.echo "The total nicknames are: " & ubound(nicknames)
wscript.echo "The nicknames are: " & join(nicknames, " ")