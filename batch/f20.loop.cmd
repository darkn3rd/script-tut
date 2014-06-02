@ECHO OFF
 
REM Note: Batch FOR loop will glob only files or only
REM  directories with /d, but not both.
 
REM iterate through each line returned from subshell
FOR /F "usebackq" %%I IN (`cmd /c dir /b`) DO (
  REM test if item is a directory
  IF EXIST %%I\NUL (
      ECHO %%I is a directory
  ) ELSE (
      ECHO %%I is not a directory
  )
)