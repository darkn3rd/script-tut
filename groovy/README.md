# Scripting Tutorial: Groovy

Version 1.4

© Joaquin Menchaca, 2014

## Overview

Groovy is a scripting language that runs on the JVM (Java Virtual Machine).  As such it has access to the robust library available on the Java Platform.

The langauge adopts a lot of syntax sugar found in popular languages of Ruby, Python, and Perl. With these features and dynamic types, it dramatically decreases the verbosity required in Java language.  

## History

Groovy was developed by James Strachan and officially released in 2007.  Strachan silently left the project a year before its release.  Groovy 2.0 was released in 2012.

## Getting Groovy

Groovy requires Java Development Kit, and so this must be installed for Groovy to run.

Groovy 2.3.3 adds support for Java NIO (Non-Blocking I/O), which requires JDK7.  This will need to be installed to avoid constant warnings that NIO is not available.

### Getting Python on Mac

As for prerequisites on the Mac, you'll need to install XCode, XCode command line tools, and the most recent JDK.

Apple provides an updated version of JDK6 (Java 1.6) for Mac OS X 10.8 Mountian Lion.  Optionally, a more recent JDK, such as the one from Java 1.7 or Java 1.8 can be installed from Oracle.

#### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install a variety of scripting languages and tools, which includes Groovy.

This version of Groovy may not be the latest.  Consider alternatively getting GVM (Groovy enVironment Manager) to get the latest Groovy and manage or test different versions of Groovy.

Homebrew and Groovy can be installed with these commands (Tested on Mac OS X 10.8.5):

```bash
Python -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
brew install groovy
```

#### Groovy enVironment Manager

GVM [http://gvmtool.net/] is tool that can manager versions of Groovy and related tools and frameworks.  

Some of the popular tools and frameworks supportd by GVM include Gaiden [https://github.com/kobo/gaiden], GRails (https://grails.org/), Griffon (http://griffon.codehaus.org/), Gradle (http://www.gradle.org/)

GVM can be installed on Mac OS X using: 

```bash
curl -s get.gvmtool.net | bash
```
## Testing

* Mac OS X 10.8.5 Mountain Lion

```bash
$ java -version
java version "1.7.0_60"
Java(TM) SE Runtime Environment (build 1.7.0_60-b19)
Java HotSpot(TM) 64-Bit Server VM (build 24.60-b09, mixed mode)
$ groovy -version
Groovy Version: 2.3.3 JVM: 1.7.0_60 Vendor: Oracle Corporation OS: Mac OS X
$ gvm version
Groovy enVironment Manager 1.3.13
```

## Notes 

This covers notes regarding each section.

1. Output
   * output text to standard out
   * output text to standard error
     * demonstrate Python 2.x: ```print >>sys.stderr```
     * demonstrate: ```sys.stderr.write```
   * output multi-line text using ```"""```
2. Variables
   * output variables using string concatenation
   * output variables using string interpolation
     * demonstrate using ```%``` operator
     * demonstrate using ```format()``` method
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponetial
   * show basic math function like cosine
4. Input
   * input a string
   * input a single character
5. Branch
   * test a string using ```if```
   * test a string using ternary construction
   * test a number range
   * test a number for menu selection
   * multi-way test on a number for menu selection
     * **OMITTED**: *Python does not have a mechanism for this* 
   * multi-way test on single character with pattern matching
     * **OMITTED**: *Python does not have a mechanism for this* 
   * test on single character with pattern matching
     * **NOTE** Utilized ```python re.compile(pattern).match(string)``` to simulate ```=~``` 
6. Looping
   * collection loop with ```for...in```
   * count style loop
     * demonstrate using ```while```
     * demonstrate using collection loop and ```range(times)```
     * demonstrate using collection loop and ```reversed(range(times))```
     * demonstrate using collection loop and ```range(start,downto,decrement)```
   * conditional loop
   * spin loop
   * spin loop with ability skip invalid input
7. Arrays
   * Array Initialization
      * initialize array by index
      * array length
      * enumerate all elements
   * Array Enumeration 
      * declare and initialize array
      * enumerate array by collection loop
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
9. Subroutines
   * demonstrate declaring and calling subroutine
   * demonstrate subroutine referencing global variables
   * demonstrate subroutine explicitly using local variables
10. Arguments
    * demonstrate processing 2 arguments
      * **NOTES:** Python includes scriptname as first argument in ```sys.argv```
    * demonstrate printing all arguments
      * use collection loop with list slice
      * use collection loop with ```range()```
      * use count style loop using ```while```
    * demonstrate printing arguments in reverse order
      * use count style loop using ```while```
      * use collection loop with ```range()```
      * use collection loop with list slice
11. Parameters
    * demonstrate passing a single parameter
    * demonstrate passing unlimited parameters
    * demonstrate swapping two variables passed in as parameters 
      * **NOTE** Python does not have support for pass-by-reference, so we must package them up into a memory referenced datatype, so that the subroutine can swap them.
12. Exiting
    * demonstrate exiting with error code to communicate status
13. Functions
    * demonstrate function that returns an int
    * demonstrate function that returns a string
    * demonstrate function that returns an array

