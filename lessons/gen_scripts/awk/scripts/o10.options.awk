#!/usr/bin/env -S gawk -f
# awk has no getopts and ARGV[0] is always the interpreter's own name
#  ("gawk"), never the script file - "invoked_as" is supplied by the
#  test harness itself via "-v invoked_as=..." (see testbox/Script.rb)
#  standing in for a real argv[0]. Flags are matched by hand against
#  each element of ARGV.
BEGIN {
  usage = "\n" \
          "Usage: " invoked_as " [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]\n" \
          "\n" \
          "  -c  Coffee\n" \
          "  -e  Espresso\n" \
          "  -l  Latte\n" \
          "  -k  Machiato\n" \
          "  -p  Capucino\n" \
          "  -m  Mocha\n" \
          "  -t  Tea\n" \
          "  -h  Display this help message\n" \
          "  -?  Display this help message\n" \
          "\n"

  flags["-c"] = "coffee"
  flags["-e"] = "espresso"
  flags["-l"] = "latte"
  flags["-k"] = "macchiato"
  flags["-p"] = "capucino"
  flags["-m"] = "mocha"
  flags["-t"] = "tea"

  count = 0
  for (i = 1; i < ARGC; i++) {
    flag = ARGV[i]
    if (flag == "-h" || flag == "-?") {
      printf "%s", usage
      exit 0
    } else if (flag in flags) {
      orders[count++] = flags[flag]
    }
  }

  if (count == 0) {
    printf "%s", usage > "/dev/stderr"
    exit 1
  }

  print ""
  print "You ordered: "
  for (i = 0; i < count; i++) {
    print "* " orders[i]
  }
}
