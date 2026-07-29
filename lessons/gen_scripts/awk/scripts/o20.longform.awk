#!/usr/bin/env gawk -f
# awk has no getopt-style parser at all, and ARGV[0] is always the
#  interpreter's own name ("gawk"), never the script file -
#  "invoked_as" is supplied by the test harness itself via
#  "-v invoked_as=..." (see testbox/Script.rb) standing in for a real
#  argv[0]. Flags (long and short) are matched by hand against each
#  element of ARGV.
BEGIN {
  usage = "\n" \
          "Usage: " invoked_as " [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]\n" \
          "\n" \
          "  --coffee,    -c N  Coffee\n" \
          "  --espresso,  -e N  Espresso\n" \
          "  --latte,     -l N  Latte\n" \
          "  --macchiato, -k N  Machiato\n" \
          "  --capucino,  -p N  Capucino\n" \
          "  --mocha,     -m N  Mocha\n" \
          "  --tea,       -t N  Tea\n" \
          "  --help,      -h    Display this help message\n" \
          "  -?                 Display this help message\n" \
          "\n"

  flags["--coffee"] = "coffee";    flags["-c"] = "coffee"
  flags["--espresso"] = "espresso"; flags["-e"] = "espresso"
  flags["--latte"] = "latte";      flags["-l"] = "latte"
  flags["--macchiato"] = "macchiato"; flags["-k"] = "macchiato"
  flags["--capucino"] = "capucino"; flags["-p"] = "capucino"
  flags["--mocha"] = "mocha";      flags["-m"] = "mocha"
  flags["--tea"] = "tea";          flags["-t"] = "tea"

  count = 0
  i = 1
  while (i < ARGC) {
    flag = ARGV[i]
    if (flag == "-h" || flag == "-?" || flag == "--help") {
      printf "%s", usage
      exit 0
    } else if (flag in flags) {
      name = flags[flag]
      n = ARGV[i + 1] + 0
      if (n == 1) {
        orders[count++] = n " " name
      } else {
        orders[count++] = n " " name "s"
      }
      i += 2
    } else {
      printf "%s", usage > "/dev/stderr"
      exit 1
    }
  }

  if (count == 0) {
    printf "%s", usage > "/dev/stderr"
    exit 1
  }

  print ""
  print "You ordered: "
  for (j = 0; j < count; j++) {
    print "* " orders[j]
  }
}
