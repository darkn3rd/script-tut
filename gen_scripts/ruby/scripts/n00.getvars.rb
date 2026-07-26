#!/usr/bin/env ruby
require "etc"
require "socket"
require "tmpdir"

# Enumerate a fixed set of well-known environment variables, printing
#  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
#  as actual environment entries on every POSIX host - fall back to
#  Ruby's own portable equivalent for each (all three work identically
#  on Windows - Etc.getlogin there falls back to ENV["USERNAME"]
#  internally) so this stays reliable anywhere. USERNAME/USERPROFILE/
#  TEMP/COMPUTERNAME are Windows-only concepts with no POSIX equivalent
#  - printed only when actually present.
user     = ENV["USER"] || Etc.getlogin
tmpdir   = ENV["TMPDIR"] || Dir.tmpdir
hostname = ENV["HOSTNAME"] || Socket.gethostname

puts "USER=#{user}"
puts "HOME=#{ENV["HOME"]}"
puts "TMPDIR=#{tmpdir}"
puts "HOSTNAME=#{hostname}"

puts "USERNAME=#{ENV["USERNAME"]}" if ENV["USERNAME"]
puts "USERPROFILE=#{ENV["USERPROFILE"]}" if ENV["USERPROFILE"]
puts "TEMP=#{ENV["TEMP"]}" if ENV["TEMP"]
puts "COMPUTERNAME=#{ENV["COMPUTERNAME"]}" if ENV["COMPUTERNAME"]
