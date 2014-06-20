# Scripting Tutorial: PowerShell

© Joaquin Menchaca, 2014

## Overview

Powershell is Microsoft's new platform for scripting and automating Windows system.  It's an environment that runs on top of the .NET platform, and has access to the wealth of .NET libraries.  There's a built-in mechanism to access OLE libraries as well, so in that sense it can easily replace the limited WSH (Windows Script Host) environment that hosted JScript and VBScript amongst other languages for scripting chores.

Powershell 2.0 is supported on Windows as early as Windows NT 5.1 (Windows XP) and Windows NT 5.2 (Windows 2003).  PowerShell 3.0 is supported on Windows NT 6.1 (Windows 7, Windows Server 2008 R2) and later.  PowerShell 4.0 is supported on Windows NT 6.2 (Windows 8 and Windows 2012) and Windows NT 6.1 with SP1 for their perspective releases. Future versions obviously will follow this pattern, and thus you'll need to get the latest Windows for the latest PowerShell.  Earlier versions of Windows do not support PowerShell officially (yes...there have been hacks), and so WSH and the traditional command shell (BATCH) may be the only options from Microsoft, but then those systems are EOL (End-of-Life) by Microsoft, and so most in the community may not even mind or have interests.

Amongst the operating system from Microsoft, various interfaces, such as installing Features and Roles on Windows releases differ, and thus, there is limited consistent interfaces amongst different versions of Windows.  Thus scripts may need to check for the operating system and use the appropriate available APIs if the scripts needs to run on different versions of Windows.  This was a similar problem with earlier versions of Windows and popular tools, as they differed in availability, licensing, and command line switches.  Such is the problem today as it was before in the past.

## Using Power Shell on Windows 

TBU - Set Policy, security, root kits...

## Getting PowerShell on Windows

TBU

## Testing

TBU

## Topics with Details 

This covers notes regarding each section.

1. **Output**
2. **Variables**
3. **Arithmetic**
4. **Input**
5. **Branch**
6. **Looping**
7. **Arrays**
8. **Associative Arrays**
9. **Subroutines** 
10. **Arguments**
11. **Parameters**
12. **Functions**