@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
:: get name of script (%~nx0 strips any path prefix, keeping just the
::  filename, e.g. if invoked as ".\o20.longform.cmd")
SET SCRIPT_NAME=%~nx0
SET ORDERS=
SET COUNT=0

:loop
IF "%~1"=="" GOTO endloop
IF "%~1"=="--coffee"    (CALL :addorder %2 coffee)    & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-c"          (CALL :addorder %2 coffee)    & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--espresso"  (CALL :addorder %2 espresso)  & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-e"          (CALL :addorder %2 espresso)  & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--latte"     (CALL :addorder %2 latte)     & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-l"          (CALL :addorder %2 latte)     & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--macchiato" (CALL :addorder %2 macchiato) & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-k"          (CALL :addorder %2 macchiato) & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--capucino"  (CALL :addorder %2 capucino)  & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-p"          (CALL :addorder %2 capucino)  & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--mocha"     (CALL :addorder %2 mocha)     & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-m"          (CALL :addorder %2 mocha)     & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--tea"       (CALL :addorder %2 tea)       & SHIFT & SHIFT & GOTO loop
IF "%~1"=="-t"          (CALL :addorder %2 tea)       & SHIFT & SHIFT & GOTO loop
IF "%~1"=="--help" GOTO usage_ok
IF "%~1"=="-h" GOTO usage_ok
IF "%~1"=="-?" GOTO usage_ok
GOTO usage_err

:endloop
IF %COUNT% EQU 0 GOTO usage_err

ECHO.
ECHO You ordered: 
FOR %%A IN (%ORDERS%) DO ECHO * %%~A
EXIT /B 0

:addorder
SET N=%1
SET NAME=%2
IF "%N%"=="1" (
  SET ORDERS=!ORDERS! "%N% %NAME%"
) ELSE (
  SET ORDERS=!ORDERS! "%N% %NAME%s"
)
SET /A COUNT+=1
GOTO :EOF

:usage_ok
ECHO.
ECHO Usage: %SCRIPT_NAME% [--coffee^|-c N] [--espresso^|-e N] [--latte^|-l N] [--macchiato^|-k N] [--capucino^|-p N] [--mocha^|-m N] [--tea^|-t N] [--help^|-h^|-?]
ECHO.
ECHO   --coffee,    -c N  Coffee
ECHO   --espresso,  -e N  Espresso
ECHO   --latte,     -l N  Latte
ECHO   --macchiato, -k N  Machiato
ECHO   --capucino,  -p N  Capucino
ECHO   --mocha,     -m N  Mocha
ECHO   --tea,       -t N  Tea
ECHO   --help,      -h    Display this help message
ECHO   -?                 Display this help message
ECHO.
EXIT /B 0

:usage_err
ECHO.>&2
ECHO Usage: %SCRIPT_NAME% [--coffee^|-c N] [--espresso^|-e N] [--latte^|-l N] [--macchiato^|-k N] [--capucino^|-p N] [--mocha^|-m N] [--tea^|-t N] [--help^|-h^|-?]>&2
ECHO.>&2
ECHO   --coffee,    -c N  Coffee>&2
ECHO   --espresso,  -e N  Espresso>&2
ECHO   --latte,     -l N  Latte>&2
ECHO   --macchiato, -k N  Machiato>&2
ECHO   --capucino,  -p N  Capucino>&2
ECHO   --mocha,     -m N  Mocha>&2
ECHO   --tea,       -t N  Tea>&2
ECHO   --help,      -h    Display this help message>&2
ECHO   -?                 Display this help message>&2
ECHO.>&2
EXIT /B 1
