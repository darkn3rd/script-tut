@ECHO OFF
:: sum is both SET and read within the same ( ... ) ELSE ( ... ) block
::  below - %var% would expand once, at parse time, before the SET /a
::  ever runs, so it'd always read as empty. Delayed expansion (!var!)
::  re-reads it at actual execution time instead.
SETLOCAL ENABLEDELAYEDEXPANSION
:: illustrative variables
:: get name of script (%~nx0 strips any path prefix, keeping just the
::  filename, e.g. if invoked as ".\j00.arguments.cmd")
SET SCRIPT_NAME=%~nx0
:: get the total number of arguments
SET /A ARG_COUNT=0
FOR %%A IN (%*) DO SET /A ARG_COUNT+=1

:: test if user entered 2 values
IF %ARG_COUNT% NEQ 2 (
  :: output usage statement to standard error
  ECHO.>&2
  ECHO You need to enter two numbers:>&2
  ECHO.>&2
  ECHO    Usage: %SCRIPT_NAME% [num1] [num2]>&2
  ECHO.>&2
) ELSE (
   :: get sum of both arguments
   SET /a sum=%1 + %2
   :: print results of both arguments and summation
   ECHO The sum of %1 and %2 is: !sum!.
)
