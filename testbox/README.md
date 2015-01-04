# Testing Box

© Joaquin Menchaca, 2014

## Overview

The idea for this area is to develop a script that can verify functionality of scripts on a given platform and environment. I can quickly expose any issues, and explore workarounds.

## Status

I developed a basic `Rakefile` that lists all the test areas to cover of any given area.  

The idea is that each tasks encapsulates testing for each group, independently from each other.  Each task will need to do the following:

* Generate a list of files to be executed for its area
  * No files exist, return that feature is not supported
  * Multiple files exist, run all tests, report summary.
  * One file exist, run that test, report findings.
* Understand how to run the test (so some environment detection)
  * Unix/Linux shell - just execute script
  * PowerShell or DOS - make use of provided run script (or use one of its own)

Considering doing some scaffolding in detection of whether the scripting platform in question and execution there-of is supported, also, maybe reporting the test environment (operating system, version, 32bit or 64 bit, distro, language platform)

Need to find a way to have some format (JSON, YAML, XML) store inputs/outputs for comparison.  At this moment, just doing output.


## The Plan

This was the original plan brainstormed on December, 2014.

These are the requirements that I have come up with:

1. Create script functions for each scripting area: A00 to M20
* Each script function will run 1 or more tests, some negative, some positive.
* Each script function will know the following:
  * name of the script(s) to run
  * designated input for each test
  * expected standard output and standard error.
* Test Runner generates list of scripts to be executed and the matching script function that should run.
* Test Runner will then execute each script using the script function and its tests.
* Test Runner will generate a report of its findings.

## Test Runner: Rake

*[Rake](https://github.com/ruby/rake) is a software task management and build automation tool. It allows you to specify tasks and describe dependencies as well as to group tasks in a namespace.* - [Wikipedia](http://en.wikipedia.org/wiki/Rake_%28software%29)  It was originated by [Jim Weirich](http://en.wikipedia.org/wiki/Jim_Weirich).


* Articles
  * [Using the Rake Build Language](http://martinfowler.com/articles/rake.html)
  * [Rake Tutorial](http://lukaszwrobel.pl/blog/rake-tutorial)
* Videos
  * [Basic Rake by Jim Weirich](https://www.youtube.com/watch?v=AFPWDzHWjEY)
* Source
  * [Rake Source](https://github.com/ruby/rake)


## Open Source Task Tools

For a test runner, I could use a task-build tool.  There are numerous ones to choose from:

* [Cake](http://coffeescript.org/documentation/docs/cake.html) - CoffeeScript based
* [Gradle](http://www.gradle.org/) - Groovy based
* [Grunt](http://gruntjs.com/) - Node based
* [Psake](https://github.com/psake/psake) - PowerShell based
* [Rake](https://github.com/ruby/rake) - Ruby based
* [SCons](http://scons.org/) - Python based
