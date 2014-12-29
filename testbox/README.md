# Testing Box

© Joaquin Menchaca, 2014

## Overview

The idea for this area is to develop a script that can verify functionality of scripts on a given platform and environment. I can quickly expose any issues, and explore workarounds.

## Plan

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
