#!/usr/bin/env groovy
def drinks = [
  Capucino: 0,
  Coffee: 0,
  Espresso: 0,
  Latte: 0,
  Machiato: 0,
  Mocha: 0,
  Tea: 0,
]

// The JVM has no supported, portable way to modify a running process's
//  own environment (System.getenv() is read-only) - a throwaway child
//  shell is used just to compute this process's would-be environment
//  plus MY_ORDERS added, and that's what gets dumped instead of this
//  JVM process's own (unmodifiable) one.
if (args.length == 0) {
  def rnd = new Random()
  drinks.keySet().each { key -> drinks[key] = rnd.nextInt(3) }
} else {
  args.each { pair ->
    def (key, qty) = pair.split(":", 2)
    drinks[key] = qty.toInteger()
  }
}

def order = drinks.sort().findAll { k, v -> v != 0 }.collect { k, v -> "${k}:${v}" }.join(",")

def envFile = new File("dump_env.out")
envFile.withWriter { w ->
  System.getenv().each { key, value -> w.writeLine("${key}=${value}") }
  w.writeLine("MY_ORDERS=${order}")
}

// Explicit flush - stdout is block-buffered (not line-buffered) once
// it's a pipe rather than a real terminal, so without this the prompt
// below might never actually reach the test harness waiting to read it.
print("MY_ORDERS set, Hit Return to continue\n")
System.out.flush()
System.in.read()

envFile.delete()
