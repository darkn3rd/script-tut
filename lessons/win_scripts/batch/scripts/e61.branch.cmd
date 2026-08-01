@echo off
REM testbox: title="findstr regex classification"
REM get input
set /p keypress=Input a character:

REM Simulate case/switch through labels, goto, and if

REM Test for digit with Findstr
ECHO %keypress% | FindStr /R "[0-9]" > NUL
IF %ERRORLEVEL% EQU 0 (ECHO  Digit) & (GOTO ENDCASE)

REM Test for uppercase letter
REM NOTE: a [A-Z] *range* is case-insensitive in findstr (a known quirk -
REM  it matches lowercase too). Enumerating each letter individually
REM  instead of using a range is case-sensitive.
ECHO %keypress% | FindStr /R "[ABCDEFGHIJKLMNOPQRSTUVWXYZ]" > NUL
IF %ERRORLEVEL% EQU 0 (ECHO  Uppercase letter) & (GOTO ENDCASE)

REM Test for lowercase letter
ECHO %keypress% | FindStr /R "[abcdefghijklmnopqrstuvwxyz]" > NUL
IF %ERRORLEVEL% EQU 0 (ECHO  Lowercase letter) & (GOTO ENDCASE)

REM Default output if nothing is found
ECHO  Punctuation, whitespace, or other
:ENDCASE
