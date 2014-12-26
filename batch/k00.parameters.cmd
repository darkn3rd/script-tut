@ECHO OFF

:: set initial temperature in degrees Fahrenheit
SET temperature=73 
:: call the subroutine, passing one parameter
CALL :celsius %temperature% 
GOTO :EOF

:: create subroutine
:celsius
  :: convert to float and calculate Celsius
  SET fahrenheit=%1
  SET /A "temperature=(%fahrenheit% - 32) * 5 / 9"

  ECHO The Celsius temperature is %temperature% degrees.
GOTO :EOF
