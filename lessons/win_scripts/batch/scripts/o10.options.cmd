@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
:: get name of script (%~nx0 strips any path prefix, keeping just the
::  filename, e.g. if invoked as ".\o10.options.cmd")
SET SCRIPT_NAME=%~nx0
SET ORDERS=
SET COUNT=0

FOR %%A IN (%*) DO (
  IF "%%A"=="-h" GOTO usage_ok
  IF "%%A"=="-?" GOTO usage_ok
  IF "%%A"=="-c" (SET ORDERS=!ORDERS! coffee) & SET /A COUNT+=1
  IF "%%A"=="-e" (SET ORDERS=!ORDERS! espresso) & SET /A COUNT+=1
  IF "%%A"=="-l" (SET ORDERS=!ORDERS! latte) & SET /A COUNT+=1
  IF "%%A"=="-k" (SET ORDERS=!ORDERS! macchiato) & SET /A COUNT+=1
  IF "%%A"=="-p" (SET ORDERS=!ORDERS! capucino) & SET /A COUNT+=1
  IF "%%A"=="-m" (SET ORDERS=!ORDERS! mocha) & SET /A COUNT+=1
  IF "%%A"=="-t" (SET ORDERS=!ORDERS! tea) & SET /A COUNT+=1
)

IF %COUNT% EQU 0 GOTO usage_err

ECHO.
ECHO You ordered: 
FOR %%D IN (%ORDERS%) DO ECHO * %%D
EXIT /B 0

:usage_ok
ECHO.
ECHO Usage: %SCRIPT_NAME% [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h^|-?]
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

:usage_err
ECHO.>&2
ECHO Usage: %SCRIPT_NAME% [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h^|-?]>&2
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
