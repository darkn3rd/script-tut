@ECHO OFF
:: get name of script (%~nx0 strips any path prefix, keeping just the
::  filename, e.g. if invoked as ".\o00.flags.cmd")
SET SCRIPT_NAME=%~nx0

IF "%1"=="-c" (ECHO You ordered a Coffee.) & EXIT /B 0
IF "%1"=="-e" (ECHO You ordered an Espresso.) & EXIT /B 0
IF "%1"=="-l" (ECHO You ordered a Latte.) & EXIT /B 0
IF "%1"=="-k" (ECHO You ordered a Machiato.) & EXIT /B 0
IF "%1"=="-p" (ECHO You ordered a Capucino.) & EXIT /B 0
IF "%1"=="-m" (ECHO You ordered a Mocha.) & EXIT /B 0
IF "%1"=="-t" (ECHO You ordered a Tea.) & EXIT /B 0
IF "%1"=="-h" GOTO usage_ok
IF "%1"=="-?" GOTO usage_ok

ECHO.>&2
ECHO Usage: %SCRIPT_NAME% [-c^|-e^|-l^|-k^|-p^|-m^|-t] [-h^|-?]>&2
ECHO.>&2
ECHO   -c  Coffee>&2
ECHO   -e  Espresso>&2
ECHO   -l  Latte>&2
ECHO   -k  Machiato>&2
ECHO   -p  Capucino>&2
ECHO   -m  Mocha>&2
ECHO   -t  Tea>&2
ECHO   -h  Display this help message>&2
ECHO   -?  Display this help message>&2
ECHO.>&2
EXIT /B 1

:usage_ok
ECHO.
ECHO Usage: %SCRIPT_NAME% [-c^|-e^|-l^|-k^|-p^|-m^|-t] [-h^|-?]
ECHO.
ECHO   -c  Coffee
ECHO   -e  Espresso
ECHO   -l  Latte
ECHO   -k  Machiato
ECHO   -p  Capucino
ECHO   -m  Mocha
ECHO   -t  Tea
ECHO   -h  Display this help message
ECHO   -?  Display this help message
ECHO.
EXIT /B 0
