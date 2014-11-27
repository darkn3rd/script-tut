@ECHO OFF

ECHO The numbers to be added are 5, 2, 4, 3, and 6.
:: call the subroutine
CALL :ADD_NUMS 5 2 4 3 6
SET result=%ERRORLEVEL%
:: output results
ECHO The result of their summation is: %result%.
GOTO :EOF

:: create the function
:ADD_NUMS
  :: initialize starting sum value
  SET /A sum=0
  :: collection loop to get each number, sum the numbers
  FOR %%A IN (%*) DO SET /A sum+=%%A
  :: output results
  EXIT /B %sum%
GOTO :EOF
