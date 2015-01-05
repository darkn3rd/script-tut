@ECHO OFF

ECHO Sending: 5, 2, 4, 3, 6
:: call the subroutine
CALL :ADD_NUMS 5 2 4 3 6
GOTO :EOF

:: create the subroutine
:ADD_NUMS
  :: initialize starting sum value
  SET /A sum=0
  :: collection loop to get each number, sum the numbers
  FOR %%A IN (%*) DO SET /A sum+=%%A
  :: output results
  ECHO The summation is: %sum%.
GOTO :EOF