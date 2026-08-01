@ECHO off
:: testbox: title="date parsing by splitting on /"
:: Call the function
CALL :SHOWDATE
GOTO :EOF

:: Create the function
:: Unlike i01 (fixed character positions - "NOTE: only works for US
:: locality"), this splits %DATE% on "/" into month/day/year tokens, so
:: it works regardless of whether month/day are zero-padded to a fixed
:: width - confirmed directly against Wine's own %DATE% format
:: (e.g. "8/1/2026", no day-name prefix, no zero-padding).
:SHOWDATE
  FOR /F "tokens=1-3 delims=/" %%a IN ("%DATE%") DO (
    SET mon=%%a
    SET day=%%b
    SET year=%%c
  )

  if %mon%==1 set mon=January
  if %mon%==2 set mon=February
  if %mon%==3 set mon=March
  if %mon%==4 set mon=April
  if %mon%==5 set mon=May
  if %mon%==6 set mon=June
  if %mon%==7 set mon=July
  if %mon%==8 set mon=August
  if %mon%==9 set mon=September
  if %mon%==10 set mon=October
  if %mon%==11 set mon=November
  if %mon%==12 set mon=December

  ECHO Today is %mon% %day%, %year%.
GOTO :EOF
