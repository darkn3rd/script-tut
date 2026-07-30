#!/usr/bin/env bash
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably
#  set as actual environment entries on every POSIX host (HOSTNAME in
#  particular is a bash shell parameter, not something bash exports to
#  child processes, unless a profile explicitly does so) - fall back to
#  each one's standard POSIX equivalent so this stays reliable anywhere.
#  USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only concepts with
#  no POSIX equivalent - printed only when actually present.
echo "USER=${USER:-$(id -un)}"
echo "HOME=$HOME"
echo "TMPDIR=${TMPDIR:-/tmp}"
echo "HOSTNAME=${HOSTNAME:-$(hostname)}"

[ -n "$USERNAME" ]     && echo "USERNAME=$USERNAME"
[ -n "$USERPROFILE" ]  && echo "USERPROFILE=$USERPROFILE"
[ -n "$TEMP" ]         && echo "TEMP=$TEMP"
[ -n "$COMPUTERNAME" ] && echo "COMPUTERNAME=$COMPUTERNAME"
