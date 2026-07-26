@ECHO OFF
REM Split %PATH% on ";" and print each entry on its own line. cmd.exe's
REM  plain FOR list-mode splits on whitespace/comma, which would break
REM  apart a directory name containing a space - repeatedly peeling off
REM  the text up to (and including) the first remaining ";" instead
REM  keeps each entry, spaces and all, intact.
SETLOCAL
SET "PATHLIST=%PATH%;"

:loop
IF "%PATHLIST%"=="" GOTO :eof
FOR /F "delims=;" %%A IN ("%PATHLIST%") DO ECHO %%A
SET "PATHLIST=%PATHLIST:*;=%"
GOTO loop
