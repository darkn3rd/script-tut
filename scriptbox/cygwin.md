### CygWin Environment

Download and install the appropriate CygWin environment.  These instructions are for 64-bit version: `setup-x86_64.exe`.  Run through the setup and select the defaults. Assuming that the setup program was installed in your Downloads folder, run CygWin64 Terminal from Start menu and then run these commands to get `apt-cyg` wrapper:

```bash
$ cd $USERPROFILE/Downloads
$ ./setup-x86_64.exe -q -P wget
$ wget http://apt-cyg.googlecode.com/svn/trunk/apt-cyg
$ chmod +x apt-cyg
$ mv apt-cyg /usr/local/bin/
```

The default CygWin 1.7.33 environment has the following tools:

* :package: awk 4.1.1 (GNU)
* :package: bc
* :package: cut (GNU Core Utils 8.23)
* :package: date (GNU Core Utils 8.23)
* :package: expr (GNU Core Utils 8.23)
* :package: grep 2.21 (GNU)
* :package: printf (GNU Core Utils 8.23) `usr/bin/printf`
* :package: sed 4.2.2 (GNU)
* :package: seq (GNU Core Utils 8.23)
* :package: tr (GNU Core Utils 8.23)
* :package: wc (GNU Core Utils 8.23)

Also, CygWin 1.7.33 has the following scripting environments:

* :package: dash
* :package: bash 4.1.17

#### Shells

* :package: bc 1.06.95: `apt-cyg install bc`
* :package: tcsh 6.18.01 `apt-cyg install tcsh`

#### Scripting Languages

* :package: Perl 5.14.4 `apt-cyg install perl`
* :package: PHP 5.5.19 `apt-cyg install php`
* :package: Python 2.7.8 `apt-cyg install python`
* :package: Ruby 2.0.0p598 (2014-11-13) `apt-cyg install ruby`
* :package: TCL 8.5.11 `apt-cyg install tcl`
