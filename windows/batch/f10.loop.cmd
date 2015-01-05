@ECHO OFF
REM count loop using for 
FOR /l %%C in (10,-1,1) DO (
  ECHO Count is %%C
)