@echo off
assoc .njs=JavaScript
ftype JavaScript="C:\Program Files\nodejs\node.exe" %1 %*
