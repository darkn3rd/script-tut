#!/usr/bin/env groovy
// Enumerate a fixed set of well-known environment variables, printing
//  "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably
//  set as actual environment entries on every POSIX host - fall back
//  to the JVM's own portable equivalent for each (all three of which
//  work identically on Windows, unlike shelling out to whoami/hostname)
//  so this stays reliable anywhere. USERNAME/USERPROFILE/TEMP/
//  COMPUTERNAME are Windows-only concepts with no POSIX equivalent -
//  printed only when actually present.
def env = System.getenv()

def user = env.USER ?: System.getProperty("user.name")
def tmpdir = env.TMPDIR ?: System.getProperty("java.io.tmpdir")
def hostname = env.HOSTNAME ?: InetAddress.getLocalHost().hostName

println "USER=${user}"
println "HOME=${env.HOME}"
println "TMPDIR=${tmpdir}"
println "HOSTNAME=${hostname}"

if (env.USERNAME)     println "USERNAME=${env.USERNAME}"
if (env.USERPROFILE)  println "USERPROFILE=${env.USERPROFILE}"
if (env.TEMP)         println "TEMP=${env.TEMP}"
if (env.COMPUTERNAME) println "COMPUTERNAME=${env.COMPUTERNAME}"
