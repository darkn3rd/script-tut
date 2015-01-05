# Scripting Tutorial: Groovy

Version 1.6

© Joaquin Menchaca, 2014

## Overview

Groovy is a scripting language that runs on the JVM (Java Virtual Machine).  As such it has access to the robust library available on the Java Platform.

The language adopts a lot of syntax sugar found in popular languages of Ruby, Python, and Perl. With these features and dynamic types, Groovy dramatically decreases the verbosity required in contrast to the Java language.  Perhaps for this reason, Groovy has become quite popular.

I personally came across Groovy as a scripting language when investigating build automation for use with continuous integration environments such as Jenkins.

Today (2014) there are a number of popular tools are developed using Groovy, such as:

* **Gaiden** [https://github.com/kobo/gaiden] - toolkit for creating documentation in MarkDown
* **Gaelyk** [http://gaelyk.appspot.com/] - toolkit for Google App Engine.
* **Gradle** [http://www.gradle.org/] - task oriented build tool similar to Rake.
* **Grafitti** [https://github.com/webdevwilson/graffiti] - a web micro-framework inspired by Sinatra.
* **Grails** [https://grails.org/] - robust web MVC framework
* **Griffon** [http://griffon.codehaus.org/] - MVC framework for desktop applications
* **Groovy enVironment Manager** [http://gvmtool.net/] - tools to manage versions of Groovy and popolar Groovy tools and frameworks.

## History

Groovy was developed by James Strachan and officially released in 2007.  Strachan silently left the project a year before its release.  Groovy 2.0 was released in 2012.

## Getting Groovy

Groovy requires Java Development Kit, and so this must be installed for Groovy to run.

Groovy 2.3 adds support for Java NIO (Non-Blocking I/O), which requires JDK7.  This will need to be installed to avoid constant warnings that NIO is not available when working with Groovy 2.3.

### Getting Groovy on Mac

As for prerequisites on the Mac, you'll need to install XCode, XCode command line tools, and the most recent JDK.

Apple provides an updated version of JDK6 (Java 1.6) for Mac OS X 10.8 Mountain Lion.  Optionally, a more recent JDK, such as the one from Java 1.7 or Java 1.8 can be installed from Oracle.

#### Homebrew

Homebrew [http://brew.sh/] is a popular single-user package management system that can install a variety of scripting languages and tools, which includes Groovy.

This version of Groovy installed by Homebrew may not be the latest stable release.  Consider alternatively installng GVM (Groovy enVironment Manager) to get the latest Groovy and manage or test different versions of Groovy.

Homebrew and Groovy can be installed with these commands (Tested on Mac OS X 10.8.5):

```bash
ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew update
brew doctor
echo export PATH='/usr/local/bin:$PATH' >> ~/.bash_profile
. ~/.bash_profile
brew install groovy
```

#### Groovy enVironment Manager

GVM [http://gvmtool.net/] is tool that can manages versions of Groovy and related tools and frameworks.

GVM can be installed on Mac OS X with an active Internet connection and using:

```bash
curl -s get.gvmtool.net | bash
```

Afterwards, you can install groovy with the following command.  It will download, compile, and install groovy.

```bash
gvm install groovy
```

## Testing

* :dvd: *__OS X 10.8.5 (Mountain Lion)__*
  * :package: Groovy 2.3.3 (GVM: `gvm install groovy`)
    * :package: Groovy Version Manager 1.3.13 (GVM: `curl -s get.gvmtool.net | bash`)
    * :package: Oracle Java™ SE Runtime Environment (build 1.7.0_60-b19)


## Notes

This covers notes regarding each section.

1. Output
   * output text to standard out
   * output text to standard error
   * output multi-line text using ```"""```
2. Variables
   * output variables using string concatenation
   * output variables using string interpolation
     * demonstrate using ```$``` in GStrings and ```println()```
     * demonstrate using ```%``` with ```printf()```
   * output variable of multi-line text
3. Arithmetic
   * show basic integer arithmetic
   * show basic boolean evaluation
   * show basic floating math with exponential
   * show basic math function like cosine
4. Input
   * input a string
   * input a single character
5. Branch
   * test a string using ```if```
   * test a string using ternary construction ```(condition) ? true : false```
   * test a number range
   * test a number for menu selection
     * demonstrate numerical comparison
     * demonstrate string comparison
   * multi-way test on a number for menu selection
   * multi-way test on single character with pattern matching
   * test on single character with pattern matching
6. Looping
   * collection loop with ```for...in```
     * demonstrate using native interface to access directory listing
       *  use collection loop
       *  use iteration with ```eachFile``` closure
     * demonstrate executing a command to a subshell and processing text output
       *  use collection loop
       *  use iteration with ```eachLine``` closure
   * count style loop
     * demonstrate using general loop construct with ```for```
     * demonstrate using iteration with ```times```
     * demonstrate using iteration with ```each``` and range operator ```..```
     * demonstrate using ```for``` collection construct and range operator ```..```
   * conditional loop
   * spin loop
   * spin loop with ability skip invalid input
7. Arrays
   * Array Initialization
      * initialize array one element at a time
        * demonstrate using index to initialize each element
        * demonstrate using append operator ```<<``` to add each element
      * array length with ```size()``` method
      * enumerate all elements
   * Array Enumeration
      * declare and initialize array
      * enumerate array one element at a time
        *  demonstrate using collection loop with ```for```
        *  demonstrate using iteration with ```each```
      * enumerate array with an index
        *  demonstrate using general ```for``` loop with a counter
        *  demonstrate using collection loop ```for``` and range operator ```..```
        *  demonstrate using interaction with ```eachWithIndex```
8. Associative Arrays
   * Associative Array Initialization
      * initialize associative array by key
      * enumerate all keys
      * enumerate all values
   * Associative Array Enumeration
      * declare and initialize associative array
      * merge two associative arrays
      * enumerate associative array by key
        *  demonstrate using collection loop with ```for```
        *  demonstrate using iteration with ```each```
9. Subroutines
   * demonstrate declaring and calling subroutine
     *  demonstrate showing formatted date
   * demonstrate subroutine referencing global variables
     *  this shows using binding variables in Groovy
   * demonstrate subroutine explicitly using local variables
     *  this shows using local variable declaration in Groovy
10. Arguments
    * demonstrate processing 2 arguments
      * **NOTES:** Retrieving the script name can be done using ```getClass().protectionDomain.codeSource.location.path.split('/')[-1]```
    * demonstrate printing all arguments
      * use collection loop
      * use iteration with ```eachWithIndex``` closure
      * use collection loop with range operator ```..```
      * use collection loop for counter and shift out first element
      * use general loop to check empty list and shift out first element
      * use count style loop using general ```for (;;)```
    * demonstrate printing arguments in reverse order
      * use count style loop using general ```for (;;)```
      * use collection loop with range operator ```..```
      * use collection loop with ```reverse()``` method
      * use iteration with ```reverse().each``` closure
11. Parameters
    * demonstrate passing a single parameter
      * demonstrate controlling degrees of significance with decimal numbers
    * demonstrate passing unlimited parameters
12. Exiting
    * demonstrate exiting with error code to communicate status
13. Functions
    * demonstrate function that returns an int
    * demonstrate function that returns a string
    * demonstrate function that returns an array
