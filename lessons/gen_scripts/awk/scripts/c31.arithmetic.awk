#!/usr/bin/env awk -f
BEGIN {
 # default CONVFMT (%.6g) truncates floats to 6 significant digits when
 # they're stringified for concatenation (as "..." cos(PI/4) below does);
 # widen it so the full double-precision PI is actually visible in the
 # output
 CONVFMT = "%.17g"

 # declare scalar variable
 PI = atan2(0, -1)

 # output results with calculation
 print "The cosine of pi/4 is: " cos(PI/4)
}
