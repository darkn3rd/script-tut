# Testing Box

© Joaquin Menchaca, 2014

## Overview

The idea for this area is to develop testing that can verify functionality of scripts on a given platform and environment. I can quickly expose any issues, and explore workarounds.

## Status

* 2014-01-05:
   * Basic framework organization.
   * Test runner (Rake) executes scripts
* 2014-01-11
   * JSON container and expected data set
   * Script class to facilitate running tests, collecting/reporting results, reporting environment.
   * TestSuite (organization, structure, reporting) completed using Rakefile
   * Adjustments to scripts, dataset, and bug fixes
   * Initial support for dynamic data in dataset
   * Discovered potential bugs in Groovy and Perl, other areas involved quirky behavior

## The Product Plan

### Scope

Develop a system that will verify the functionality of each script, and report the findings.

### Organization of Script Tutorial

Each set of scripts are organized in a main topic category of **A** to **M**, which is further organized in sub-category, of **0** to **9**.

This category will be followed **0** to **9** methods to do the particular category.  If the first script, **0** is missing, then the following scripts are alternative methods (workarounds) for implementing the absent feature.

*Example*:

* A00 - A0 category, 1st script
* A10 - A1 category, 1st script
* B00 - B0 category, 1st script
* B01 - B0 category, 2nd script (alternative method)
* B02 - B0 category, 3rd script (alternative method)
* C01 - C0 category, 1st alt method for absent feature
* C02 - C0 category, 2nd alt method for absent feature

### Product Requirements

The testing system will have a test harness or test runner that will run test cases.

* **Test Runner**
  * dynamically general list of scripts
  * execute variable number of scripts per category
  * generate resulting report of pass/fail
* **Test Cases**
  * test cases will organized by main category **A** to **M**.
  * test cases will run 1+ tests (negative, positive)
  * dynamically load input and output
    * input - arguments or standard input
    * output - standard error or standard output
      * exit code (optinal)

## The Product Implementation

### Overview

After some research, the easiest path for such a system was to use a task oriented build tool, with rake being the first choice.

The rake file, currently called `testbox.rake` will use the rake tool as the test runner with embedded tasks in the rakefile that will contain the test cases.

This system will perform the following features:

 * Environment detection for reporting and executing scripts
 * Dynamic generation of scripts to be tested
 * Dynamic configuration of expected inputs and results (`expecteed.json`)

#### Test Data

The test data contains the following format:

```JavaScript
{
  plan01: [{"out": "Script says blah"}],
  plan01: [{"arg": "", "err": "Usage: blah"},
           {"arg": "3 4", "Some output here"],
  plan03: [{"in": "Name\n", "out": "Hello Name."}],
  plan04: [{"in": "Name\nquit\n", "out": "Hello Name!\nEnter your name (quit to Exit): "}]
}
```

## Notes

Here are issues with current test suite:

* Booleans (C10):
   * scripting languages will represent true as `1` or `true`
   * need language dependent substitute to compare properly, leaving as is for now
* Floating Point (C20):
   * precision varies on support of scripting languages engine.
   * leave as is to compare, otherwise can round value down for comparison
* Associative Arrays (H10):
   * hash order is not guaranteed, depends on internal hash algorithm
   * some scripting languages, groovy, recall order at which items are inserted

## Research

### Ruby Rake Tool

*[Rake](https://github.com/ruby/rake) is a software task management and build automation tool. It allows you to specify tasks and describe dependencies as well as to group tasks in a namespace.* - [Wikipedia](http://en.wikipedia.org/wiki/Rake_%28software%29)  It was originated by [Jim Weirich](http://en.wikipedia.org/wiki/Jim_Weirich).


* Articles
   * [Using the Rake Build Language](http://martinfowler.com/articles/rake.html)
   * [Rake Tutorial](http://lukaszwrobel.pl/blog/rake-tutorial)
   * Videos
   * [Basic Rake by Jim Weirich](https://www.youtube.com/watch?v=AFPWDzHWjEY)
* Source
   * [Rake Source](https://github.com/ruby/rake)

### Test Build Tools

For a test runner, I could use any task-build tool as there are numerous:

* [Cake](http://coffeescript.org/documentation/docs/cake.html) - CoffeeScript based
* [Gradle](http://www.gradle.org/) - Groovy based
* [Grunt](http://gruntjs.com/) - Node based
* [Psake](https://github.com/psake/psake) - PowerShell based
* [Rake](https://github.com/ruby/rake) - Ruby based (most ubiquitous)
* [SCons](http://scons.org/) - Python based
