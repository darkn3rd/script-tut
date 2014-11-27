@ECHO OFF
:: illustrative variables
SET SCRIPT_NAME=%~n0 :: get name of script
:: get the total number of arguments
SET /A ARG_COUNT=0
FOR %%A IN (%*) DO SET /A ARG_COUNT+=1

:: test if user entered 2 values
IF %ARG_COUNT% NEQ 2 (
  # output usage statement to standard error
  ECHO. 2>&1
  ECHO You need to enter two numbers: 2>&1
  ECHO. 2>&1
  ECHO. 2>&1
  ECHO    Usage: %SCRIPT_NAME% [num1] [num2]" 2>&1
) ELSE (
   SET /a sum=%1 + %2 :: get sum of both arguments
   :: print results of both arguments and summation
   ECHO The sum of %1 and %2 is: %sum%.
)
