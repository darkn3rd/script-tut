#!/usr/bin/env perl -w
# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to a
#  portable equivalent for each (Sys::Hostname/File::Spec are core
#  modules, no install needed; getpwuid is wrapped in eval since it's
#  unimplemented on native Windows Perl builds) so this stays reliable
#  anywhere. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are Windows-only
#  concepts with no POSIX equivalent - printed only when actually
#  present.
use Sys::Hostname;
use File::Spec;

my $user     = $ENV{USER} // eval { scalar getpwuid($<) } // '';
my $tmpdir   = $ENV{TMPDIR} // File::Spec->tmpdir();
my $hostname = $ENV{HOSTNAME} // eval { hostname() } // '';

print "USER=$user\n";
print "HOME=" . ($ENV{HOME} // '') . "\n";
print "TMPDIR=$tmpdir\n";
print "HOSTNAME=$hostname\n";

print "USERNAME=$ENV{USERNAME}\n"       if defined $ENV{USERNAME};
print "USERPROFILE=$ENV{USERPROFILE}\n" if defined $ENV{USERPROFILE};
print "TEMP=$ENV{TEMP}\n"               if defined $ENV{TEMP};
print "COMPUTERNAME=$ENV{COMPUTERNAME}\n" if defined $ENV{COMPUTERNAME};
