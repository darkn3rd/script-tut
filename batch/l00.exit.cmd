@ECHO OFF
:::::: illustrative variables ::::::
:: get name of script
SET SCRIPT_NAME=%0
:: get the total number of arguments
SET /A ARG_COUNT=0
FOR %%A IN (%*) DO SET /A ARG_COUNT+=1
:: Error Codes
SET ERROR_INVALID_ARGS=10022
SET ERROR_SUCESS=0

:::::: main logic ::::::

IF %ARG_COUNT% LSS 1 (
   CALL :USAGE_MESSAGE
) ELSE (
   CALL :ADD_NUMS %*
)

EXIT /B %ERRORLEVEL%

:::::: USAGE_MESSAGE Function ::::::
:USAGE_MESSAGE
  :: print helpful instructions
  ECHO. 1>&2
  ECHO You need to one of more integers: 1>&2
  ECHO. 1>&2
  ECHO. 1>&2
  ECHO    Usage: %SCRIPT_NAME% [num1] [num2] [num3] ... 1>&2
  ECHO. 1>&2

  EXIT /B %ERROR_INVALID_ARGS%
GOTO :EOF
:::::: ADD_NUMS Function ::::::
:ADD_NUMS

  SET /A sum=0
  :: Iterate and sum up numbers
  FOR %%A IN (%*) DO SET /A sum+=%%A
  :: output results
  ECHO The summation is: %sum%.

  EXIT /B %ERROR_SUCESS%
GOTO :EOF
