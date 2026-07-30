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

REM ELSE must stay on the same line as the preceding block's closing
REM  paren, or cmd.exe treats the IF as already finished.
IF %selection% equ 1 (
  ECHO You selected a Coffee
) ELSE IF %selection% equ 2 (
  ECHO You selected an Espresso
) ELSE IF %selection% equ 3 (
  ECHO You selected a Latte
) ELSE IF %selection% equ 4 (
  ECHO You selected a Machiato
) ELSE IF %selection% equ 5 (
  ECHO You selected a Capucino
) ELSE IF %selection% equ 6 (
  ECHO You selected a Mocha
) ELSE IF %selection% equ 7 (
  ECHO You selected a Tea
) ELSE (
  ECHO You have not entered a valid selection
)
