#!/usr/bin/env gawk -f
BEGIN {
  split("Capucino Coffee Espresso Latte Machiato Mocha Tea", keys, " ")
  for (i in keys) drinks[keys[i]] = 0

  if (ARGC == 1) {
    srand()
    for (i in keys) drinks[keys[i]] = int(rand() * 3)
  } else {
    for (i = 1; i < ARGC; i++) {
      split(ARGV[i], parts, ":")
      drinks[parts[1]] = parts[2]
    }
  }

  n = asorti(drinks, sorted)
  order = ""
  for (i = 1; i <= n; i++) {
    key = sorted[i]
    if (drinks[key] != 0) {
      if (order == "") order = key ":" drinks[key]
      else order = order "," key ":" drinks[key]
    }
  }

  # Assigning into ENVIRON genuinely calls the real setenv() underneath
  #  (confirmed empirically: a system()-spawned child process sees it).
  ENVIRON["MY_ORDERS"] = order

  # Dump via a real shelled-out `env`, not by iterating ENVIRON
  #  ourselves, to stay consistent with every other language's version
  #  of this lesson. Explicit /usr/bin/env, not bare "env": a shell's
  #  tracked-alias cache for bare command names can latch onto a
  #  *different* env.exe already on PATH (e.g. Git for Windows bundles
  #  its own) whose own runtime doesn't see this process's
  #  freshly-exported variables - confirmed empirically while debugging
  #  this project's shell-family n20 lessons.
  system("/usr/bin/env > dump_env.out")

  print "MY_ORDERS set, Hit Return to continue"
  fflush()
  # getline ... < "-", not bare getline - bare getline would read from
  #  the "files" named in ARGV (our own "Key:Qty" arguments) rather
  #  than actual standard input.
  getline line < "-"

  system("rm -f dump_env.out")
}
