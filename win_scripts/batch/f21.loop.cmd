@ECHO OFF
REM Note: Command Shell (BATCH) does not have conditional
REM  loop constructions, but it can be simulated through
REM  labels and goto statements.

:LOOP
  SET /p answer=Enter your name (quit to Exit): 
  IF "%answer%"=="quit" GOTO END
  ECHO Hello %answer%!
  GOTO LOOP
:END
