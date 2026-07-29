#!/usr/bin/env pwsh
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to
#  .NET's own portable equivalent for each (all three work identically
#  on Windows) so this stays reliable anywhere. USERNAME/USERPROFILE/
#  TEMP/COMPUTERNAME are Windows-only concepts with no POSIX equivalent
#  - printed only when actually present.
$user = if ($env:USER) { $env:USER } else { [Environment]::UserName }
$tmpdir = if ($env:TMPDIR) { $env:TMPDIR } else { [System.IO.Path]::GetTempPath() }
$hostname = if ($env:HOSTNAME) { $env:HOSTNAME } else { [Environment]::MachineName }

Write-Output "USER=$user"
Write-Output "HOME=$env:HOME"
Write-Output "TMPDIR=$tmpdir"
Write-Output "HOSTNAME=$hostname"

if ($env:USERNAME)     { Write-Output "USERNAME=$env:USERNAME" }
if ($env:USERPROFILE)  { Write-Output "USERPROFILE=$env:USERPROFILE" }
if ($env:TEMP)          { Write-Output "TEMP=$env:TEMP" }
if ($env:COMPUTERNAME) { Write-Output "COMPUTERNAME=$env:COMPUTERNAME" }
