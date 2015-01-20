@ECHO off
REM integer arithmatic math example
SET width=5
SET length=6

REM calculate area
SET /a area=width * length

REM output integer arithmetic math results
ECHO The area of a square (width=%width%, length=%length%) is %area%
