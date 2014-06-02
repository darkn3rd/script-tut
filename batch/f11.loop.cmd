@ECHO OFF
REM Note that BATCH does not have conditional loop constructions,
REM  but it can be simulated through labels and goto statements.
 
:LOOP
SET /p answer=Enter your name (quit to Exit): 
IF "%answer%"=="quit" GOTO END
ECHO Hello %answer%!
GOTO LOOP
:END