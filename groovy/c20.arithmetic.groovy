#!/usr/bin/env groovy
// floating-point math
PI     = 3.14159265359             // defaults to java.math.BigDecimal
radius = 3                         // defaults to java.lang.Integer
area   = PI * Math.pow(radius, 2)  // defaults to java.lang.Double
 
// output results of floating point math
println "The area of a circle is: " + area
