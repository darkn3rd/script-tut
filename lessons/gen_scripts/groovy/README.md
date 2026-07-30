# Scripting Tutorial: Groovy

Version 1.8

© Joaquin Menchaca, 2014-2026

## Overview

**[Groovy](https://groovy-lang.org/)** is a scripting language that runs on the JVM (Java Virtual Machine).  As such it has access to the robust library available on the Java Platform. Groovy adopts a lot of syntax sugar found in popular languages of Ruby, Python, and Perl. With these features and dynamic types, Groovy dramatically decreases the verbosity required in contrast to the Java language.  Perhaps for this reason, Groovy has become quite popular.

I personally came across Groovy as a scripting language when investigating build automation for use with continuous integration environments such as **[Jenkins](https://www.jenkins.io/)** and **[Spinnaker](https://spinnaker.io/)**.

Around 2014, there were a number of popular tools are developed using Groovy, such as:

Today Groovy projects are active and modernizig.  

* **[Gradle](http://www.gradle.org/)** - task oriented build tool similar to Rake.
* **ttps://grails.org/** - robust web MVC framework inspired by Ruby on Rails. 
* **[Spock Framework ](https://spockframework.org/)**- a highly expressive testing and specification framework for Java and Groovy applications.
* **[Micronaut](https://micronaut.io/)** - JVM-based polyglot microservice framework created by OCI (the long-time stewards of Grails)
* **[Geb](https://groovy.apache.org/geb/)** - a Groovy-centric wrapper on top of Selenium WebDriver. It abstracts away Selenium's verbose API by utilizing a jQuery-like content selection syntax and a robust Page Object pattern natively driven by Groovy 
* **[Jenkins Pipelines](https://www.jenkins.io/doc/book/pipeline/)** - a workflow engine powering the world's most widely used open-source automation server
* **[NextFlow](https://nextflow.io/)** - a specialized workflow framework and Domain Specific Language (DSL) for data science and bioinformics. 

Since 2014, some popular projects have ended, become inactive, or have been abandoned:

* **[Gaiden](https://github.com/kobo/gaiden)** - toolkit for creating documentation in MarkDown
* **[Gaelyk](https://web.archive.org/web/20160216120234/http://gaelyk.appspot.com/) (web archive)** - toolkit for Google App Engine.
* **[Grafitti](https://github.com/webdevwilson/graffiti)** - a web micro-framework inspired by Sinatra.  The community has moved on to [Ktor](https://ktor.io/) or [Micronaut](https://micronaut.io/). 
* **[Griffon](http://griffon-framework.org/)** [http://griffon.codehaus.org/] - MVC framework for desktop applications

### History

**[Groovy](https://groovy-lang.org/)** was created in 2003 by James Strachan to serve as a fast, dynamic, and expressive scripting language that could run seamlessly on the Java Virtual Machine (JVM). At the time, Java was highly dominant but widely criticized for being slow to evolve, overly verbose, and terrible for rapid prototyping.

#### Why Groovy

* **Eliminate Boilerplate**: In 2003, writing simple Java files required excessive boilerplate (defining classes, public static voids, getters/setters, etc.) just to print text or open a file.
* **A Native "Glue" Language**: Strachan wanted a dynamic script language that didn't just run on the JVM, but could natively interact with Java's massive library ecosystem without complex binding wrappers.
* **Zero Learning Curve for Java Devs**: Unlike other languages, Groovy was tailored so that roughly 95% of standard Java code is also valid Groovy syntax.

#### The Massive Ruby Influence

Strachan was heavily inspired by Ruby's syntax and philosophical focus on programmer happiness. When building Groovy, several core abstractions were lifted directly from Ruby's playbook ([ref](https://melix.github.io/blog/2015/02/who-is-groovy.html)):

* **Metaprogramming & Expandability**: Just like Ruby allows "monkey patching," Groovy introduced a MetaClass mechanism. This allowed developers to dynamically inject new methods and properties into existing classes at runtime.
* **The Holy "Grails" Movement**: When Ruby on Rails exploded in popularity around 2005, the Groovy community quickly cloned its structure to create Grails (originally Groovy on Rails). It brought the exact same "convention over configuration" paradigm straight into the enterprise Java ecosystem
* **Ranges and Closures**: Ruby's distinct approach to block structures, execution closures, and range types (`1..10`) heavily shaped how Groovy handles inline data structures and functional programming loops.

#### Releases

Below are the releaaes and major features. 

* Groovy 1.0 — January 2, 2007
  * **The Foundation**: First production-stable release introducing standard Groovy syntax, native integration with Java libraries, and dynamic scripting on the JVM.
  * **Ruby-inspired Features**: Built-in support for closures, loose typing, ranges (`1..10`), and multi-line strings.
  * **Dynamic Metaprogramming**: Provided the initial infrastructure allowing developers to dynamically add or alter methods at runtime.
* Groovy 2.0 — July 2, 2012
  * **Static Compilation (`@CompileStatic`)**: Allowed developers to opt out of dynamic behavior for specific blocks of code, generating bytecode identical in performance to native Java.
  * **Static Type Checking (`@TypeChecked`)**: Added a mechanism to catch code typos and syntax errors at compile-time instead of runtime.
  * **JDK 7 Support**: Fully integrated with Java 7's `InvokeDynamic` bytecode instruction, vastly accelerating dynamic method invocation speeds.
* Groovy 3.0 — February 7, 2020
  * **Modern Operators**: Introduced popular code-shorthand syntax including the Elvis assignment operator (`?=`), identity operators (`===`), and safe index parsing.
* Groovy 4.0 — January 25, 2022
  * **The "Parrot" Parser**: Implemented a brand-new, flexible compiler parser that fundamentally aligned Groovy's syntax options with modern Java. 
  * **Java Lambda Support**: Enabled native Java-style lambdas `((x, y) -> x + y)` alongside traditional Groovy closures.
  * **Native Records & Sealed Classes**: Brought complete syntax compatibility for native Java Records and Sealed Classes/Interfaces introduced in modern JDKs.
  * **Native Records & Sealed Classes**: Brought complete syntax compatibility for native Java Records and Sealed Classes/Interfaces introduced in modern JDKs.
  * **Built-in Type Checkers**: Added built-in macros for compile-time format validation (such as checking regular expressions or SQL syntax accuracy during compilation).
* Groovy 5.0 — August 21, 2025
  * **JDK 17+ Optimization**: Re-architected core compiler processes to take full advantage of modern long-term support (LTS) Java virtual machines.
  * **Design-by-Contract Support**: Introduced built-in AST (Abstract Syntax Tree) macro annotations like @Decreases and @Modifies to build constraint checks directly into class structures.
  * **Revamped REPL**: Redesigned the interactive command-line environment (groovysh) to support intelligent, multi-line contextual autocompletion.

## Getting Groovy

Below are some ways you can install **[Groovy](https://groovy-lang.org/)**.

> **IMPORTANT**: You must have OpenJDK or JDK installed before installing Groovy.  See [Java README.md](../../compiled_lang/README.md).

### General: GVM (Groovy enVironment Manager)

This tool **[GVM](https://gvmtool.net/)** is deprecated since 2015 and completely replaced with **[SDKMAN!](https://sdkman.io/)**. This original was used to manage versions of Groovy and GRails, but has expanded to manage Scala, Kotlin, and other JVM languages.  

### General: SDKMAN! 

**[SDKMAN!](https://sdkman.io/)** manages SDKs on the Java platform. Using this, you can install **[Groovy](https://groovy-lang.org/)**.

```bash
# Install Groovy
sdk install groovy 5.0.7
sdk use groovy 5.0.7
```

### General: ASDF

**[ASDK](https://asdf-vm.com/)** is a universal runtime version manager that uses modular plugins to manage the software. You can use this to install **[Groovy](https://groovy-lang.org/)**.

```bash
# Install Groovy
asdf plugin-add groovy https://github.com/weibemoura/asdf-groovy.git
asdf install groovy 5.0.7
asdf global groovy 5.0.7
```

### macOS: Homebrew

You can use **[Homebrew](<https://brew.sh/)>)** to install the latest **[Groovy](https://groovy-lang.org/)**.  If you do not have 
**[OpenJDK](https://openjdk.org/)** installed, this formula will install it for you.

```bash
# Install latest Groovy
brew install groovy
```

### Windows: Chocolatey

You can use [**Chocolatey**](https://chocolatey.org/) to install the latest **[Groovy](https://groovy-lang.org/)**

```powershell
# Install Groovy
choco install -y groovy
```

## Testing

* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 Groovy 5.0.7
    * 📦 OpenJDK Runtime Environment (Azul Zulu 11.88.17 build 11.0.31+11)
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * **Shell**: PowerShell 5.1.26100.8875
    * 📦 Groovy Version: 3.0.25 JVM: 17.0.19 Vendor: Amazon.com Inc. OS: Windows 11
      * 📦 OpenJDK Runtime Environment Corretto-17.0.19.10.1 (build 17.0.19+10-LTS))
  * **Shell**: Command Shell (C:\Windows\System32\cmd.exe)
    * 📦 Groovy Version: 3.0.25 JVM: 17.0.19 Vendor: Amazon.com Inc. OS: Windows 11
      * 📦 OpenJDK Runtime Environment Corretto-17.0.19.10.1 (build 17.0.19+10-LTS))

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
* [A history of the Groovy programming language](https://dl.acm.org/doi/10.1145/3386326) by Paul King