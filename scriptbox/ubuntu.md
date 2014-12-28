# ScriptBox: Ubuntu Guide
@2014 Joaquin Menchaca

## Overview

These are my collective notes on setting up a system that can run these scripts.

## Ubuntu 12.04.5 LTS (Precise Pangolin)

```bash
$ lsb_release -a 2> /dev/null | grep Description | cut -d$'\t' -f2
Ubuntu 12.04 LTS
```

### Installing Shells

```bash
sudo apt-get install dash
sudo apt-get install bash
sudo apt-get install tcsh
sudo apt-get install ksh
```

### Installing Scripting Languages

```bash
sudo apt-get install gawk
sudo apt-get install tcl8.5
sudo apt-get install ruby
sudo apt-get install perl
sudo apt-get install php5-cli
sudo apt-get install python
sudo apt-get install groovy
```

This will install the following packages as of December 28th, 2014:

* **Awk**: GNU Awk 3.1.8
* **Groovy**: 1.8.6 (JVM: 1.6.0_33)
* **Perl**: 5.14.2
* **PHP**: 5.3.10
* **Python**: 2.7.3
* **Ruby**: 1.8.7
* **Shells**
  * **Bourne Again Shell** (`bash`): GNU bash 4.2.25
  * **C Shell** (`tcsh`): 6.17.06-2
  * **Korn Shell** (`ksh`): AT&T Research (ksh) 93u
  * **POSIX Shell** (`sh`): Debian Almquist Shell (dash) 0.5.7-2
* **TCL**: 8.5.11
