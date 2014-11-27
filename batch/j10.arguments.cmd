@echo off
:: get the total number of arguments
SET /A ARG_COUNT=0
FOR %%A IN (%*) DO SET /A ARG_COUNT+=1

:: Exit if there are no arguments
IF %ARG_COUNT% EQU 0 GOTO END

:: set initial counter
SET /A count=1

:: Enumerate arguments (print them)
:: NOTE: shift will not work inside FOR loop, so we do this

ECHO The arugments passed are:

:LOOP
:: exit loop if we processed them all
IF %count% GTR %ARG_COUNT% GOTO END
:: output results
ECHO  item %count%: %1
:: increment counter
SET /A count+=1
:: move next argument into %1
SHIFT
GOTO LOOP
:END
