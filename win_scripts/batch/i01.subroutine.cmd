@ECHO off
:: Call the function
CALL :SHOWDATE
GOTO :EOF

:: Create the function
:: NOTE - This only works for US locality
:SHOWDATE
  SET year=%DATE:~10,4%
  SET mon=%DATE:~4,2%
  SET day=%DATE:~7,2%

  if %mon%==01 set mon=January
  if %mon%==02 set mon=February
  if %mon%==03 set mon=March
  if %mon%==04 set mon=April
  if %mon%==05 set mon=May
  if %mon%==06 set mon=June
  if %mon%==07 set mon=July
  if %mon%==08 set mon=August
  if %mon%==09 set mon=September
  if %mon%==10 set mon=Ooctober
  if %mon%==11 set mon=November
  if %mon%==12 set mon=December

  ECHO Today is %mon% %day%, %year%.
GOTO :EOF
