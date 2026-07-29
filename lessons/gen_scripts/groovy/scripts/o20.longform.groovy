#!/usr/bin/env groovy
// Groovy's args (like Java's) excludes the script's own name - the
//  script's own compiled-from source file location stands in for
//  argv[0] instead.
def scriptName = new File(getClass().protectionDomain.codeSource.location.path).name

def usage = """
Usage: ${scriptName} [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]

  --coffee,    -c N  Coffee
  --espresso,  -e N  Espresso
  --latte,     -l N  Latte
  --macchiato, -k N  Machiato
  --capucino,  -p N  Capucino
  --mocha,     -m N  Mocha
  --tea,       -t N  Tea
  --help,      -h    Display this help message
  -?                 Display this help message

"""

def flags = [
  "--coffee": "coffee", "-c": "coffee",
  "--espresso": "espresso", "-e": "espresso",
  "--latte": "latte", "-l": "latte",
  "--macchiato": "macchiato", "-k": "macchiato",
  "--capucino": "capucino", "-p": "capucino",
  "--mocha": "mocha", "-m": "mocha",
  "--tea": "tea", "-t": "tea",
]

def orders = []
def i = 0
while (i < args.length) {
  def arg = args[i]
  if (arg == "--help" || arg == "-h" || arg == "-?") {
    print(usage)
    System.exit(0)
  } else if (flags.containsKey(arg)) {
    def name = flags[arg]
    def n = args[i + 1].toInteger()
    orders << "${n} " + (n == 1 ? name : name + "s")
    i += 2
  } else {
    System.err.print(usage)
    System.exit(1)
  }
}

if (orders.isEmpty()) {
  System.err.print(usage)
  System.exit(1)
}

println ""
println "You ordered: "
orders.each { order -> println "* " + order }
