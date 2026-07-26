#!/usr/bin/env groovy
// Groovy's args (like Java's) excludes the script's own name - the
//  script's own compiled-from source file location stands in for
//  argv[0] instead.
def scriptName = new File(getClass().protectionDomain.codeSource.location.path).name

def usage = """
Usage: ${scriptName} [-c|-e|-l|-k|-p|-m|-t] [-h|-?]

  -c  Coffee
  -e  Espresso
  -l  Latte
  -k  Machiato
  -p  Capucino
  -m  Mocha
  -t  Tea
  -h  Display this help message
  -?  Display this help message

"""

if (args.length != 1) {
  System.err.print(usage)
  System.exit(1)
}

switch (args[0]) {
  case "-c": println "You ordered a Coffee."; System.exit(0)
  case "-e": println "You ordered an Espresso."; System.exit(0)
  case "-l": println "You ordered a Latte."; System.exit(0)
  case "-k": println "You ordered a Machiato."; System.exit(0)
  case "-p": println "You ordered a Capucino."; System.exit(0)
  case "-m": println "You ordered a Mocha."; System.exit(0)
  case "-t": println "You ordered a Tea."; System.exit(0)
  case "-h":
  case "-?":
    print(usage)
    System.exit(0)
  default:
    System.err.print(usage)
    System.exit(1)
}
