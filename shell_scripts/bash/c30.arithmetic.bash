#!/usr/bin/env bash
readonly PI=3.14159265359    #  La valeur approximative de π

echo the cosine of pi/4 is:  $(awk "BEGIN {print cos($PI/4)}")
