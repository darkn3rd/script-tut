' create empty list
Dim nicknames()
' resize array and insert element by index
ReDim Preserve nicknames(1) : nicknames(0) = "bob"
ReDim Preserve nicknames(2) : nicknames(1) = "ed"
ReDim Preserve nicknames(3) : nicknames(2) = "steve"
ReDim Preserve nicknames(4) : nicknames(3) = "ralph"
ReDim Preserve nicknames(5) : nicknames(4) = "joe"
ReDim Preserve nicknames(6) : nicknames(5) = "deb"
ReDim Preserve nicknames(7) : nicknames(6) = "kate"

WScript.Echo "The total nicknames are: " & UBound(nicknames)
WScript.Echo "The nicknames are: " & Join(nicknames, " ")