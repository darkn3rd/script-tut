#!/usr/bin/env awk -f
BEGIN {
 # default CONVFMT (%.6g) truncates floats to 6 significant digits when
 # they're stringified for concatenation (as "..." area "." below does);
 # widen it so the full double-precision PI is actually visible in the
 # output
 CONVFMT = "%.17g"

 # declare scalar variables
 PI     = atan2(0, -1)
 radius = 3

 # calculate area
 area   = PI * radius^2

 # output results
 print "The area of a circle (radius=" radius ") is: " area "."
}
