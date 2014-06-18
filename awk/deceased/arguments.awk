#!/bin/awk -f
BEGIN {
  # illustrative variables
  script_name = ARGV[0]   # get script name
  # utility variables
  output      = ""        # set initial output string

  print "The arguments passed are:"

  # get index from array ARGV  with quasi-collection loop 
  #  Note: index fetched come out of order in AWK.
  for (count in ARGV) {
    # fetch arg given current index
    arg = ARGV[count]
    # skip to next iteration if invalid arg
    if (arg == script_name) { continue }
    # process valid args
    if (output == "") {
      # build initial output string
      #output = "  item " count ": " arg "\n"
      output = count
    } else {
      # add new content to output string
      count = count/1
      lastcount = lastcount/1
      print "DEBUG count=>" count " > lastcount=>" lastcount ": " (count > lastcount)
      if (count > lastcount) {
        # append string to final output
        output = output " " count
        #output = output "  item " count ": " arg "\n"
      } else {
        # prepend string to final output
        #output = "  item " count ": " arg "\n" output
        output = count " " output
      }
      print "OUTPUT =>" output
    }
    
    # save index for next iteration
    lastcount = count
  }
  
  # print compiled output string
  printf "%s", output
}
