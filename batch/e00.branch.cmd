@ECHO off
REM get input
SET /p number=Input a number: 
REM evaluate 3 conditions (if/elseif/else construct not supported)
IF %number% gtr 0 (ECHO Number is greater than 0)
IF %number% lss 0 (ECHO Number is less than 0)
IF %number% equ 0 (ECHO Number is 0)