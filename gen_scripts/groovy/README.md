# Scripting Tutorial: Groovy

Version 1.7

© Joaquin Menchaca, 2014-2026

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


## History

**Groovy** was developed by James Strachan and officially released in 2007.  Strachan silently left the project a year before its release.

* Tested with Groovy 5.0.6

## Getting Groovy

Groovy requires **Java Development Kit**, and so this must be installed for **Groovy** to run.

### Installation with Runtime Version Managers

Runtime version managers can install and manage different versions of Groovy and Java JDK across multiple platforms. 

#### Groovy enVironment Manager (Deprecated)

This tool is deprecated and completely replaced with **[SDKMan](https://sdkman.io/)**. 

#### SDKMan

**[SDKMan](https://sdkman.io/)** manages SDKs on the Java platform. 

```bash
# Install SDKMan
curl -s "https://sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
# Install Java
sdk install java 17.0.19-amzn
sdk default java 17.0.19-amzn
# Install Groovy
sdk install groovy 5.0.7
sdk use groovy 5.0.7
```

#### ASDF

**[ASDK](https://asdf-vm.com/)** is a universal runtime version manager that uses modular plugins to manage the software. 

```bash
# Install ASDF
sudo apt install curl git
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
# Install Java
asdf plugin add java https://github.com/halcyon/asdf-java.git
asdf install java corretto-17.0.19.10.1
asdf global java corretto-17.0.19.10.1
# Install Groovy
asdf plugin-add groovy https://github.com/weibemoura/asdf-groovy.git
asdf install groovy 5.0.7
asdf global groovy 5.0.7
```

### macOS: Homebrew

You can use [Homebrew](https://brew.sh/) to install Groovy along with the dependent Java JDK. This will install the latest versions (2026-07-20):

* [Azul Zulu Build of OpenJDK](https://www.azul.com/downloads/?package=jdk#zulu) 11.88.17
* [Groovy](https://groovy.apache.org/download.html) 5.0.7

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Install OpenJDK (Azul Zulu) and Groovy
brew install groovy
```


## Testing

* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 Groovy 5.0.7
    * 📦 OpenJDK Runtime Environment (Azul Zulu 11.88.17 build 11.0.31+11)


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

## Links

Some articles I came across along the way of searching for Groovy related material:

* [Processing Files In Place With Groovy](http://blog.davidehringer.com/groovy/processing-files-place-groovy/)
* [Groovy Goodness: Using the replaceAll Methods from String](http://mrhaki.blogspot.com/2009/10/groovy-goodness-using-replaceall.html)
