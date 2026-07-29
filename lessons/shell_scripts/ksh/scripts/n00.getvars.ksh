#!/usr/bin/env ksh
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to each
#  one's standard POSIX equivalent so this stays reliable anywhere.
#  USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only concepts with
#  no POSIX equivalent - printed only when actually present.
user="${USER:-$(id -un)}"
tmpdir="${TMPDIR:-/tmp}"
hostname="${HOSTNAME:-$(hostname)}"

print "USER=$user"
print "HOME=$HOME"
print "TMPDIR=$tmpdir"
print "HOSTNAME=$hostname"

[[ -n "$USERNAME" ]]     && print "USERNAME=$USERNAME"
[[ -n "$USERPROFILE" ]]  && print "USERPROFILE=$USERPROFILE"
[[ -n "$TEMP" ]]         && print "TEMP=$TEMP"
[[ -n "$COMPUTERNAME" ]] && print "COMPUTERNAME=$COMPUTERNAME"
