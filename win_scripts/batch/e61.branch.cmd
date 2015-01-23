@echo off
REM get input
set /p keypress=Input a character:

REM Simulate case/switch through labels, goto, and if

REM Test for digit with Findstr
ECHO %keypress% | FindStr /R "[0-9]" > NUL
IF %ERRORLEVEL% EQU 0 (ECHO  Digit) & (GOTO ENDCASE)

REM Test for alpha-numeric (cannot test for case)
REM NOTE: Findstr cannot distinguish case, so [a-z] is the same as [A-Z]
ECHO %keypress% | FindStr /R "[A-Z]" > NUL
IF %ERRORLEVEL% EQU 0 (ECHO  Alphabet character) & (GOTO ENDCASE)

REM Default output if nothing is found
ECHO  Punctuation, whitespace, or other
:ENDCASE
