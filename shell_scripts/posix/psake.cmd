@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-psake .\psakefile.ps1 -Quiet; if (-not $psake.build_success) { exit 1 }"
