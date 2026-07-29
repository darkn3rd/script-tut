#!/usr/bin/env sh
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to each
#  one's standard POSIX equivalent so this stays reliable anywhere.
#  USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only concepts with
#  no POSIX equivalent - printed only when actually present.
user="${USER:-$(id -un)}"
tmpdir="${TMPDIR:-/tmp}"
hostname="${HOSTNAME:-$(hostname)}"

echo "USER=$user"
echo "HOME=$HOME"
echo "TMPDIR=$tmpdir"
echo "HOSTNAME=$hostname"

[ -n "$USERNAME" ]     && echo "USERNAME=$USERNAME"
[ -n "$USERPROFILE" ]  && echo "USERPROFILE=$USERPROFILE"
[ -n "$TEMP" ]         && echo "TEMP=$TEMP"
[ -n "$COMPUTERNAME" ] && echo "COMPUTERNAME=$COMPUTERNAME"
