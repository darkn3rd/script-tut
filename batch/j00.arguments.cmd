@ECHO OFF
:: illustrative variables
:: get name of script
SET SCRIPT_NAME=%0 
:: get the total number of arguments
SET /A ARG_COUNT=0
FOR %%A IN (%*) DO SET /A ARG_COUNT+=1

:: test if user entered 2 values
IF %ARG_COUNT% NEQ 2 (
  # output usage statement to standard error
  ECHO. 1>&2
  ECHO You need to enter two numbers: 1>&2
  ECHO. 1>&2
  ECHO. 1>&2
  ECHO    Usage: %SCRIPT_NAME% [num1] [num2] 1>&2
  ECHO. 1>&2
) ELSE (
   :: get sum of both arguments
   SET /a sum=%1 + %2
   :: print results of both arguments and summation
   ECHO The sum of %1 and %2 is: %sum%.
)
