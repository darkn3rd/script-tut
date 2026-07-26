#!/usr/bin/env gawk -f
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to each
#  one's standard POSIX equivalent (via a real shelled-out command, since
#  gawk itself has no builtin for either) so this stays reliable
#  anywhere. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only
#  concepts with no POSIX equivalent - printed only when actually
#  present.
function getcmd(cmd,    line) {
  cmd | getline line
  close(cmd)
  return line
}

BEGIN {
  user = ("USER" in ENVIRON) ? ENVIRON["USER"] : getcmd("id -un")
  tmpdir = ("TMPDIR" in ENVIRON) ? ENVIRON["TMPDIR"] : "/tmp"
  hostname = ("HOSTNAME" in ENVIRON) ? ENVIRON["HOSTNAME"] : getcmd("hostname")

  print "USER=" user
  print "HOME=" ENVIRON["HOME"]
  print "TMPDIR=" tmpdir
  print "HOSTNAME=" hostname

  if ("USERNAME" in ENVIRON)     print "USERNAME=" ENVIRON["USERNAME"]
  if ("USERPROFILE" in ENVIRON)  print "USERPROFILE=" ENVIRON["USERPROFILE"]
  if ("TEMP" in ENVIRON)         print "TEMP=" ENVIRON["TEMP"]
  if ("COMPUTERNAME" in ENVIRON) print "COMPUTERNAME=" ENVIRON["COMPUTERNAME"]
}
