#!/usr/bin/env tclsh
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to a
#  portable equivalent for each (info hostname is a Tcl builtin; the
#  username fallback shells out to whoami, the same "exec" idiom this
#  project's other Tcl lessons already use) so this stays reliable
#  anywhere. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only
#  concepts with no POSIX equivalent - printed only when actually
#  present.
if {[info exists env(USER)]} {
  set user $env(USER)
} else {
  set user [exec whoami]
}

if {[info exists env(HOME)]} {
  set home $env(HOME)
} else {
  set home ""
}

if {[info exists env(TMPDIR)]} {
  set tmpdir $env(TMPDIR)
} else {
  set tmpdir "/tmp"
}

if {[info exists env(HOSTNAME)]} {
  set hostname $env(HOSTNAME)
} else {
  set hostname [info hostname]
}

puts "USER=$user"
puts "HOME=$home"
puts "TMPDIR=$tmpdir"
puts "HOSTNAME=$hostname"

if {[info exists env(USERNAME)]} {
  puts "USERNAME=$env(USERNAME)"
}
if {[info exists env(USERPROFILE)]} {
  puts "USERPROFILE=$env(USERPROFILE)"
}
if {[info exists env(TEMP)]} {
  puts "TEMP=$env(TEMP)"
}
if {[info exists env(COMPUTERNAME)]} {
  puts "COMPUTERNAME=$env(COMPUTERNAME)"
}
