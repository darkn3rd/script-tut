REM ---------------------------
REM Check WSL features enabled
REM ---------------------------
@echo off
echo.
gsudo dism ^
  /online ^
  /get-featureinfo ^
  /featurename:"Microsoft-Windows-Subsystem-Linux" |^
findstr /B /C:"Feature Name" /C:"Description" /C:"State" & echo.

echo.
gsudo dism ^
  /online ^
  /get-featureinfo ^
  /featurename:"VirtualMachinePlatform" |^
findstr /B /C:"Feature Name" /C:"Description" /C:"State" & echo.
