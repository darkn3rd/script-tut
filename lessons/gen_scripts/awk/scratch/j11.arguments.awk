#!/bin/awk -f
BEGIN {
  # illustrative variables
  script_name = ARGV[0]   # get script name
  # utility variables
  output      = ""

  print "The arguments passed are:"

  # pseudo collection loop that enumerates keys
  for (count in ARGV) {
    arg = ARGV[count]                     # fetch arg given index
    if (arg == script_name) { continue }  # skip if not real arg
    if (output == "") {
      # build initial output string
      output = "  item " count ": " arg "\n"
    } else {
      if (count > lastcount) {
        # append string to final output
        output = output "  item " count ": " arg "\n"
      } else {
        # prepend string to final output
        output = "  item " count ": " arg "\n" output
      }
    }
    
    # save index for later use
    lastcount = count
  }
  
  # print compiled output string
  printf "%s", output
}
