@echo off
REM get input
set /p keypress=Input a character: 
 
REM Simulate case/switch through labels, goto, and if
 
REM Test for digit with Findstr
ECHO %keypress% | FindStr /R "[0-9]"
IF %ERRORLEVEL% EQU 0 (ECHO "Digit") & (GOTO ENDCASE)
 
REM Test for alpha-numeric (cannot test for case)
REM Findstr cannot distinguish case, for it uses broken RegEx engine
ECHO %keypress% | FindStr /R "[A-Z]"
IF %ERRORLEVEL% EQU 0 (ECHO "Alphabet character") & (GOTO ENDCASE)
 
REM Default output if nothing is found
ECHO "Punctuation, whitespace, or other"
:ENDCASE