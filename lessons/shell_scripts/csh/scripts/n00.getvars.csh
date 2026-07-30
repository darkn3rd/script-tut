#!/usr/bin/env tcsh
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to each
#  one's standard POSIX equivalent so this stays reliable anywhere.
#  USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only concepts with
#  no POSIX equivalent - printed only when actually present. tcsh
#  imports inherited environment variables into its own variable table,
#  so an existing one (setenv'd or not) is readable/testable the same
#  way as any other "set" variable ($VARNAME / $?VARNAME).
if ($?USER) then
  set user = "$USER"
else
  set user = `id -un`
endif

if ($?TMPDIR) then
  set tmpdir = "$TMPDIR"
else
  set tmpdir = "/tmp"
endif

if ($?HOSTNAME) then
  set hostname_val = "$HOSTNAME"
else
  set hostname_val = `hostname`
endif

echo "USER=$user"
echo "HOME=$HOME"
echo "TMPDIR=$tmpdir"
echo "HOSTNAME=$hostname_val"

if ($?USERNAME) echo "USERNAME=$USERNAME"
if ($?USERPROFILE) echo "USERPROFILE=$USERPROFILE"
if ($?TEMP) echo "TEMP=$TEMP"
if ($?COMPUTERNAME) echo "COMPUTERNAME=$COMPUTERNAME"
