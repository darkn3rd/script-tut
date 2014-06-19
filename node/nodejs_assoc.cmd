@echo off
assoc .nod=JavaScript
ftype JavaScript="C:\Program Files\nodejs\node.exe" %1 %*
