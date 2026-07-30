@ECHO OFF

REM Note: Batch FOR loop will glob only files or only
REM  directories with /d, but not both.
REM Note: As alternative, just using subshell through
REM  usebackq feature

REM collection loop using subshell
REM   iterates through each line returned from subshell
FOR /F "usebackq" %%I IN (`cmd /c dir /b dirtest`) DO (
  REM test if item is a directory
  IF EXIST dirtest\%%I\NUL (
      ECHO %%I is a directory
  ) ELSE (
      ECHO %%I is not a directory
  )
)
