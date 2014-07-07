# Lanuage Demand and Popularity

This is an ad-hoc index on scripting languages.  The language popularity may reflect impetus of web development, and so may not be reflective on what is actually used for system administration or tool development on Linux, Unix, and Windows platforms.


1. Python
2. PHP
3. JavaScript family (ActionScript, JScript)
4. Perl
5. Ruby
6. Groovy
7. Bourne Shell family (sh, bash, ksh, dash)
8. LUA
9. TCL
10. Powershell
11. Awk
12. VBScript
13. REXX
14. C Shell

## Notes

Recently (June 2014), JavaScript has the highest demand amongst the scripting languages. After JavaScript, Python has surpassed both Perl and PHP in job demands.  This differs from popularity indexes, such as TIOBE (http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html) and Sourceforge (http://lang-index.sourceforge.net/). These show PHP to be more popular than JavaScript, Perl, and Python.

http://www.indeed.com/jobtrends?q=PHP%2C+JavaScript%2C+Ruby%2C+Perl%2C+Python&l=

I am also seeing  a lot of Job demand for Groovy, which is popular for continuos integration and build automation.  It is used with Gradle build system, and is used for automation for Jenkins.

There have been some job demand for Powershell, which has surpassed bash (Bourne AgainShell).

http://www.indeed.com/jobtrends?q=Powershell%2C+Bash%2C+Groovy%2C+VBScript&l=


#### Microsoft Platform

Visual Basic has a high demand on TIOBE indexes, more so than VB.NET.  This is interesting, considering these languages are related to VBScript.  VBScript still remains very popular today, but in job demands, there is more recent interest in PowerShell.  

For WSH hosted languages, JScript has little coverage, and is hard to find any documentation.  VBScript is the most popular WSH language.  Other WSH hosted languages, will be all but invisible.  

As far as popularity index goes, VBScript seems to be more popular. I have my doubts. For Job Trends, demand for Powershell outpaced VBScript in 2012. 

From what I seen, on the Windows platform for SaaS products that use Windows Server and IIS with ASP.NET, a variety of languages will be used.  There will be Batch (Command Shell) and PowerShell, with some borrowed VBScript scripts (if they are well developed and in the public domain).  There may even be some use of GNU Core Utilities, such as the date command, as Microsoft's facilities for this are either too weak (e.g. Command Shell) or complex (e.g. exporting variables from Powershell into Command Shell).  Other scripting langauges may be used, such as Perl, Ruby, and Python.  In one case, I saw use of Rake (Ruby) and Psake (Powershell) for building JavaScript assets for a web service.

http://www.indeed.com/jobtrends?q=VBScript%2C+JScript%2C+Powershell&l=

#### JavaScript

JavaScript takes a back seat to Python and PHP as far as popularity goes on TIOBE and Sourceforge, but it has the highest demand from employers.  This might have something to do with Node.js, which is a server platform that uses JavaScript for the scripting language.  Client scripters can transfer their skills to server side scripting now, so we may see Node.js supplant PHP over time.  

For old school web scripters, Flash uses a form of the language, called ActionScript, and even Adobe Acrobat PDF scripts support scripting forms with JavaScript.  Here's a small list of where JavaScript is used besides web browsers:

  - OSA Hosted Scripting language to Mac OS automation - http://en.wikipedia.org/wiki/JavaScript_OSA
  - WSH Hosted Scripting language for Windows automaton - http://en.wikipedia.org/wiki/JScript
  - ActionScript for automating Flash - http://en.wikipedia.org/wiki/Actionscript
  - Automation of Acrobat PDF - http://www.adobe.com/devnet/acrobat/javascript.html
  - Server Side Web Scripting - http://en.wikipedia.org/wiki/Node.js

#### Bourne Shell Family

The historical Bourne Shell shares the same basic programming structures as the original Bourne Shell.  Shells like Z Shell (zsh), Korn Shell (ksh) and Bourne Again Shell (bash), are drop in replacements for the original shell, and are thus while extending the features, are backwards compatible.  Almquist Shell (ash) and Debian Almquist shells (dash) are direct substitutes that were created to avoid licensing or copyright problems. All of these have been updated to support POSIX compliance, and thus can be called POSIX shell, referring to the upgraded syntax and features specified in the standard.

It is dubiously hard to track, which of any are more popular than the other, as they all share the same syntax language, but with different features.  Also, these tools depend significantly on external tools, which a variety of tools available or documented in POSIX (http://pubs.opengroup.org/onlinepubs/009695399/idx/utilities.html) and GNU Core Utils (http://www.gnu.org/software/coreutils/).

In the industry, shell scripting is the staple core skill required.  On any Linux environment, you can be sure that bash will be required.  On Unix environments that are based on SVR Unix, such as AIX or Solaris, ksh will be desired.

http://www.indeed.com/jobtrends?q=Bash%2C+%22Korn+Shell%22%2C+ksh%2C+awk%2C+csh%2C+tcl&l=

#### C Shell, Tcl, and Awk

C Shell is an all but forgotten language.  The shell is riddled with syntactical bugs, and the community has not taken interest to document the language or fix its problems.  Even with this, you'll see some ideas borrowed from CSH and used in more popular languages.

As for Awk, you'll see this used in niche places.  Probably not full blown scripts, as Perl or another language will takes its place.  Awk is still evolving, with occasional features added from Gawk (GNU Awk) that comes with GNU Core Utils.

TCL was popular as a test tool for embedded systems in the 1990s and was also popular for automating interactive text programs with a tool called Expect before SSH became popular.  TCL was extended with graphical widget system called Tk.  This made Tcl/Tk famous, as programming graphical interfaces on Unix and Linux was challenging and limited, at least before the release of KDE and Gnome Desktop.  It also offered away to have one code base for cross-platform applications on Mac OS (Classic), Windows '95 OSes, the X Windows System used on Linux and Unix.  Tcl/Tk became quite a popular multimedia platform, before web applications (HTML or Flash) became ubiquitous.  

These days with rich UX (user experiences) on gadgets, web, or desktop applications, Tcl/Tk is just too limited, and with plethora of robust scripting languages, TCL does command much of an audience.  Still, in some niche areas, such as networking equipment from Cisco and F5, TCL can be used to automate some complex chores on such equipment.

http://www.indeed.com/jobtrends?q=%22Korn+Shell%22%2C+ksh%2C+awk%2C+csh%2C+tcl&l=


## Runtime Environments

Many scripting languages run on their own application virtual machine, which is an engine that provides operating system features in a restricted environment.  This allows languages to be dynamic as well as robust, and such virtual machine engines have become quite complex given the needs for running applications behind web servers.

There have been ports of scripting languages to popular virtual machines, such as Java VM or CLR VM (the engine used with .NET or Mono).  A few have uniquely born on these virtual machines, such as PowerShell on CLR VM and Groovy on Java VM.

* Virtual Machines
  * CLR VM - http://en.wikipedia.org/wiki/Common_Language_Runtime
  * Java VM - http://en.wikipedia.org/wiki/Java_virtual_machine
* Implmentations
  * CLR VM
    * Microsoft .NET - http://www.microsoft.com/net
    * Mono - http://www.mono-project.com/Main_Page
  * Java VM
    * Open JDK - http://openjdk.java.net/
    * Oracle Java - http://www.oracle.com/technetwork/java/index.html
    * IKVM - http://www.ikvm.net/
* Some CLR VM Scripting Languages
  * PowerShell - http://www.microsoft.com/powershell (link redirected)
  * IronRuby - http://ironruby.net/ (hasn't been updated since 2011)
  * IronPython - http://ironpython.net/
  * IronScheme - http://ironscheme.codeplex.com/
  * JScript.NET - http://msdn.microsoft.com/en-us/library/ms974588.aspx
  * JavaScript.NET (Google's V8 engine) - http://javascriptdotnet.codeplex.com/
  * CSharp Script - http://csharpscript.codeplex.com/
* Some Java VM Scripting Languages
  * Groovy - http://groovy.codehaus.org/
  * Jython - http://www.jython.org/
  * JRuby - http://www.jruby.org/
  * Scala - http://www.scala-lang.org/
  * Clojure - http://clojure.org/
  * Jacl - http://sourceforge.net/projects/tcljava/
  * Rhino (JavaScript) - https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Rhino
  
