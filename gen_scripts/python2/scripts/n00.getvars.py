#!/usr/bin/env python2
import getpass
import os
import socket
import tempfile

# Enumerate a fixed set of well-known environment variables, printing
# "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
# as actual environment entries on every POSIX host - fall back to
# Python's own portable equivalent for each (all three work identically
# on Windows) so this stays reliable anywhere. USERNAME/USERPROFILE/
# TEMP/COMPUTERNAME are Windows-only concepts with no POSIX equivalent -
# printed only when actually present.
user = os.environ.get("USER") or getpass.getuser()
tmpdir = os.environ.get("TMPDIR") or tempfile.gettempdir()
hostname = os.environ.get("HOSTNAME") or socket.gethostname()

print "USER=%s" % user
print "HOME=%s" % os.environ.get("HOME", "")
print "TMPDIR=%s" % tmpdir
print "HOSTNAME=%s" % hostname

if "USERNAME" in os.environ:
    print "USERNAME=%s" % os.environ["USERNAME"]
if "USERPROFILE" in os.environ:
    print "USERPROFILE=%s" % os.environ["USERPROFILE"]
if "TEMP" in os.environ:
    print "TEMP=%s" % os.environ["TEMP"]
if "COMPUTERNAME" in os.environ:
    print "COMPUTERNAME=%s" % os.environ["COMPUTERNAME"]
