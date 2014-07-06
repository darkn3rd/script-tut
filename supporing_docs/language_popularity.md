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

Recently (June 2014), I am seeing the popularity of Python for job demands, and this has jumped ahead of Perl and PHP.  JavaScript has the highest demand for jobs, but do not have highest popularity in TIOBE and Sourceforge indexes.  Groovy is showing a lot of recent demand, especially for build automation and continious integration. Also with job demands, Powershell has surpased Bourne Again Shell (bash), but are still relatively small compared to JavaScript, Perl, PHP, and Python.  

#### Microsoft Platform

Visual Basic has a high demand on TIOBE indexes, more so than VB.NET.  This is interesting, considering these langauges are related to VBScript.  VBScript still remains very popular today, but in job demands, there is more recent interest in PowerShell.  

For WSH hosted langauges, JScript has little coverage, and is hard to find any documenation.  VBScript is the most popular WSH language.  Other WSH hosted langauges, will be all but invisible.  

As far as popularity goes, it is still split between VBScript and Powershell, with growing demand for PowerShell.  In reality though, a mix of solutions will be used for automation, such as Perl, Ruby, Python, Batch (Command Shell), and Powershell.  It usually depends on what is easiest to implement.

#### JavaScript

JavaScript takes a back seat to Python and PHP as far as popularity goes on TIOBE and Sourceforge, but it has the highest demand from employers.  This might have something to do with Node.js, which is a server platform that uses JavaScript for the scripting language.  Client scripters can transfer their skills to server side scripting now, so we may see Node.js supplant PHP over time.  

For old school web scripters, Flash uses a form of the language, called ActionScript, and even Adobe Acrobat PDF scripts support scripting forms with JavaScript.  There's a small list of where JavaScript is used beside web browsers:

  - OSA Hosted Scripting language to Mac OS automation - http://en.wikipedia.org/wiki/JavaScript_OSA
  - WSH Hosted Scripting language for Windows automaton - http://en.wikipedia.org/wiki/JScript
  - ActionScript for automating Flash - http://en.wikipedia.org/wiki/Actionscript
  - Automation of Acrobat PDF - http://www.adobe.com/devnet/acrobat/javascript.html
  - Server Side Web Scripting - http://en.wikipedia.org/wiki/Node.js

#### Bourne Shell Family

The historical Bourne Shell shares the same basic programming structures as the orgiinal Bourne Shell.  Shells like Z Shell (zsh), Korn Shell (ksh) and Bourne Again Shell (bash), are drop in replacements for the original shell, and are thus while extending the features, are backwards compatible.  Almquist Shell (ash) and Debian Almquist shells (dash) are direct substitutes that were created to avoid licensing or copyright problems. All of these have been updated to support POSIX compliance, and thus can be called POSIX shell, refering to the upgraded syntax and features specified in the standard.

It is dubiously hard to track, which of any are more popular than the other, as they all share the same syntax language, but with different features.  Also, these tools depend significantly on external tools, which a variety of toosl available or documented in POSIX (http://pubs.opengroup.org/onlinepubs/009695399/idx/utilities.html) and GNU Core Utils (http://www.gnu.org/software/coreutils/).

In the industry, shell scripting is the staple core skill required.  On any Linux environment, you can be sure that bash will be required.  On Unix environments that are based on SVR Unix, such as AIX or Solaris, ksh will be desired.

#### C Shell and Awk

This is an all but forgotten language.  The language is riddled with syntactical bugs, and the community has not taken interest to document the language.  I only dabbled with this because it was popular a long time ago when there was only the original Bourne Shell and Awk, and also because there is hardly any documenation on it anywhere.  I thought it was useful to look at it, as some ideas were borrowed from it and used in other languages.

As for Awk, you'll see this used in niche places.  Probably not full blown scripts, as Perl or another language will takes its place.  Awk is still evolving, with ocassional features added from Gawk (GNU Awk) that comes with GNU Core Utils.

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
    * DotGNU - http://www.dotgnu.org/
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
  