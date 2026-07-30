@ECHO OFF

:: set initial temperature in degrees Fahrenheit
SET temperature=73 
:: call the subroutine, passing one parameter
CALL :celsius %temperature% 
GOTO :EOF

:: create subroutine
:celsius
  :: SET /A is integer-only - batch has no floating point at all - so to
  ::  keep one decimal digit of precision, scale by 10 before dividing,
  ::  and add half the divisor first so the result rounds (matching how
  ::  every other language's %.1f-style formatting rounds) instead of
  ::  just truncating (which would give 22.7 instead of 22.8 here).
  SET fahrenheit=%1
  SET /A "scaled=((%fahrenheit% - 32) * 5 * 10 + 4) / 9"
  SET /A "whole=scaled / 10"
  SET /A "frac=scaled %% 10"

  ECHO The Celsius temperature is %whole%.%frac% degrees.
GOTO :EOF
