@ECHO off
REM integer arithmatic math example
SET width=5
SET length=6
SET /a area=width * length
 
REM output integer arithmatic math results
ECHO The area of a square(width=%width%,length=%length%) is %area%
  
REM boolean logic example
SET true=1
SET false=0
SET group_a=%true%
SET group_b=%false%
SET group_c=%true%
 
REM Note -- Windows/DOS Batch/Cmd doesn't support boolean logic math,
REM  so we need nested IF conditions to simulate boolean logic math
 
REM result = group_a & group_b
IF %group_a% == %true% (
   IF %group_b% == %true% (SET result=%true%) ELSE (SET result=%false%)
) ELSE (SET result=%false%)
 
REM result = result | %true%
IF %result% == %false% (
  IF %group_c% == %true% (SET result=%true%)
)
 
REM output boolean logic math results
ECHO The statement (true AND false OR true) is %result%