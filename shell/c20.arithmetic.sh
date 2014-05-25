#!/bin/sh
readonly PI=3.1415927     #  La valeur approximative de π
 
echo the cosine of pi / 4 is:  $(awk "BEGIN {print cos($PI/4)}")