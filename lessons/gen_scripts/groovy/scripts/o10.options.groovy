#!/usr/bin/env groovy
// Groovy's args (like Java's) excludes the script's own name - the
//  script's own compiled-from source file location stands in for
//  argv[0] instead.
def scriptName = new File(getClass().protectionDomain.codeSource.location.path).name

def usage = """
Usage: ${scriptName} [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]

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

def flags = [
  "-c": "coffee",
  "-e": "espresso",
  "-l": "latte",
  "-k": "macchiato",
  "-p": "capucino",
  "-m": "mocha",
  "-t": "tea",
]

def orders = []
for (arg in args) {
  if (arg == "-h" || arg == "-?") {
    print(usage)
    System.exit(0)
  } else if (flags.containsKey(arg)) {
    orders << flags[arg]
  }
}

if (orders.isEmpty()) {
  System.err.print(usage)
  System.exit(1)
}

println ""
println "You ordered: "
orders.each { drink -> println "* " + drink }
