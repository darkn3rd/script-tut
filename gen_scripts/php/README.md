# Scripting Tutorial: PHP

© Joaquin Menchaca, 2014-2026

Version 1.4

## Overview

## Overview

PHP began in 1995 as **Personal Home Page Tools**, a small set of Perl scripts Rasmus Lerdorf wrote to track visits to his own online résumé. In 1997 it was rewritten in C as PHP/FI 2.0, but it wasn't yet the language people know today.

**PHP 3** (June 1998) is where it actually became a language — Andi Gutmans and Zeev Suraski rewrote the parser from scratch and it was renamed **PHP: Hypertext Preprocessor**, a recursive acronym. **PHP 4** (May 2000) introduced the Zend Engine, and **PHP 5** (July 2004) brought proper object-oriented programming (Zend Engine 2).

A planned **PHP 6**, built around native Unicode support, was abandoned in 2010 after years of struggling with the added complexity; most of its non-Unicode features were folded into the PHP 5.3/5.4 line instead, and the next major release skipped the number entirely to avoid confusion with the abandoned effort.

**PHP 7** (December 2015) was the real turning point: a new engine (PHPNG) roughly doubled performance, and the long-deprecated original `mysql` extension was finally removed. **PHP 8** (November 2020) added a JIT compiler, union types, attributes, and the `match` expression; **PHP 8.1** (November 2021) added enums, readonly properties, and fibers. PHP has shipped a new major/minor version every November since 7.0.

Along the way, PHP became the dominant language for server-side web scripting, it's the engine behind WordPress, and was foundational to early Facebook and Wikipedia. Its ease of embedding directly in HTML (`<?php ... ?>`) made it an easy on-ramp for web development in the late '90s and 2000s, and that install base is a big part of why it still runs a large share of the web today.

### Famous PHP projects

* **WordPress** — powers a huge share of the web's CMS-driven sites
* **Wikipedia / MediaWiki** — the wiki engine behind Wikipedia
* **Facebook** — built in PHP originally; led to HHVM and the Hack language for performance at scale
* **Slack** — historically ran significant backend portions on PHP/Hack via HHVM
* **[Drupal](https://www.drupal.org/project/drupal), [Joomla](https://www.joomla.org/), [Magento](https://github.com/magento/magento2)/Adobe Commerce** — major CMS and e-commerce platforms
* **Etsy, Tumblr** — both PHP-based in their earlier, high-growth years
* **[Laravel](https://laravel.com/), [Symfony](https://symfony.com/)** — the two dominant modern PHP frameworks

### OPNsense: PHP as system-configuration glue

**[OPNsense](https://opnsense.org/)** (a FreeBSD-based firewall/router, forked from pfSense, which itself traces back to **[m0n0wall](https://m0n0.ch/wall/index.php)**) uses PHP as orchestration glue between a declarative config file and the live system state, not just as a web-app language:

* All system configuration (interfaces, firewall rules, DHCP, DNS, VPN, users) lives in one file, `config.xml`, instead of the usual scattered `/etc` files
* PHP parses that XML into an in-memory `$config` array, mutates it when the GUI submits a change, and serializes it back on save
* Applying a change means PHP generates the real daemon config files (DHCP, DNS resolver, packet-filter rules) and shells out to FreeBSD tools (`ifconfig`, `pfctl`, `service`) to reload them
* Optional features (VPN types, IDS/IPS, routing daemons) ship as PHP plugins that hook into the same config model

## Getting PHP

### macOS: Homebrew

```bash
brew install php
```

### Windows: Chocolatey

```powershell
# Install Chocolatey
choco install -y php

# Enable the intl extension in php.ini
$phpIni = "C:\tools\php85\php.ini"
(Get-Content $phpIni) -replace '^;extension=intl$', 'extension=intl' | Set-Content $phpIni

# Verify it loaded
php -m | findstr intl
```

This assumes that there's a `C:\tools\php85\php.ini`. If that is not the case, you need to create one:

```powershell
Copy-Item "C:\tools\php85\php.ini-production" "C:\tools\php85\php.ini"
```

### Windows: UCRT64 (MSYS2)

There's actually no php package within the MSYS2 ecosystem.  You can install with Chocolatey, and then reference it in UCRT64 bash shell environment.

📓 **NOTE**: The Windows native PHP will execute **`cmd.exe`** for `exec()`, `shell_exec()`, or `proc_open()`.  Thus virtual POSIX paths like `/etc/localtime` cannot be supported.

```bash
echo 'export PATH="$PATH:/c/tools/php85"' >> ~/.bash_profile
```

## Testing

* 📀 *__OS X 10.8.5 (Mountain Lion)__*
  * 💿 PHP 5.3.26 (default)
* 📀 *__macOS 26.5 (Tahoe)__*
  * 📦 `PHP 8.5.8 (cli) (built: Jul  1 2026 03:46:27) (NTS)`
* 📀 *__Windows 11 Home__* (`Microsoft Windows NT [Version 10.0.26200.8875]`)
  * 🐚 PowerShell 5.1.26100.8875
    * 📦 PHP 8.5.8 (cli) (built: Jul  1 2026 04:03:04) (NTS Visual C++ 2022 x64)
  * 🐚 Cygwin 3.6.10-1
    * 📦 PHP 8.1.28 (cli) (built: Dec 22 2025 15:47:43) (NTS)
* 📀 *__Windows 7 SP1 64-bit__* (`Windows NT 6.1`)
    * 📦 MSVCR 11.00.51106.1, PHP 5.5.13 (http://windows.php.net/download/)

## Topics with Details 

This covers notes regarding each section.

1. **Output**
2. **Variables**
   * output variables using string concatenation using concatenation operator ```.```
   * output variables using string interpolation.
3. **Arithmetic**
4. **Input**
5. **Branch**
   * select on number using ```if```
   * select on character using ```switch```
     * **NOTES** 
        * *PHP cannot do pattern matching in switch, so creative alternative utilized*
        * *POSIX selectors for internationalization are fully supported in PHP*
   * select on character using ```if```
     * **NOTE** *POSIX selectors for internationalization are fully supported in PHP*
6. **Looping**
   * iterative (count) loop
     * alternative shows conditional loop with counter illustrated
   * conditional loop
   * collection loop
7. **Arrays**
   * populate array using index
   * populate array using list of items
   * enumerate array using collection loop
8. **Associative Arrays**
   * Create Associative Array using key index
   * Create Associative Array using supplied list of key and value pairs
9. **Subroutines** 
   * utilize subroutine that prints the current date in "Month Day, Year" format
10. **Arguments**
    * demonstrate testing for two arguments
    * print list of all arguments with count
      * iterative loop with index (default as optimal)
      * collection loop
        * **NOTE** *Collection loop is sub-optimal as PHP includes name of running script in the array, so we must test for it in each iteration to skip it*
    * print list of all arguments in reverse with count
11. **Parameters**
   * demonstrate passing 1 parameter
     * utilize subroutine that prints celsius temperature when supplied fahrenheit temperature
   * demonstrate passing unlimited parameters
12. **Functions**
    * demonstrate returning integer
      * returns summation of all numbers passed into function 
    * demonstrate returning string
      * returns capitalized string from lower case string 
