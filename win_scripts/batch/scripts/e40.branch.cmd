@ECHO off
REM cmd.exe has no clean way to hold a multi-line string in one
REM  variable - the closest is an obscure "linefeed variable" trick via
REM  delayed expansion, uglier than just printing each line - so each
REM  menu line gets its own ECHO instead of one "menu" var.
ECHO Select an item from the menu.
ECHO.
ECHO   1 - Coffee
ECHO   2 - Espresso
ECHO   3 - Latte
ECHO   4 - Machiato
ECHO   5 - Capucino
ECHO   6 - Mocha
ECHO   7 - Tea
ECHO.
SET /p selection=Make your selection: 

REM Windows/DOS Batch/Cmd has no switch statement - simulate one through
REM  labels and goto (see also e61.branch.cmd).
IF %selection% equ 1 GOTO CASE1
IF %selection% equ 2 GOTO CASE2
IF %selection% equ 3 GOTO CASE3
IF %selection% equ 4 GOTO CASE4
IF %selection% equ 5 GOTO CASE5
IF %selection% equ 6 GOTO CASE6
IF %selection% equ 7 GOTO CASE7
GOTO DEFAULT

:CASE1
ECHO You selected a Coffee
GOTO ENDCASE
:CASE2
ECHO You selected an Espresso
GOTO ENDCASE
:CASE3
ECHO You selected a Latte
GOTO ENDCASE
:CASE4
ECHO You selected a Machiato
GOTO ENDCASE
:CASE5
ECHO You selected a Capucino
GOTO ENDCASE
:CASE6
ECHO You selected a Mocha
GOTO ENDCASE
:CASE7
ECHO You selected a Tea
GOTO ENDCASE
:DEFAULT
ECHO You have not entered a valid selection
:ENDCASE
