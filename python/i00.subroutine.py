#!/usr/bin/env python
import time

# create subroutine
def show_date():
   print "Today is %s." % time.strftime("%B %d, %Y")

# call the subroutine
show_date()
