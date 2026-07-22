@echo off
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-psake .\psakefile.ps1 -Quiet"
