#!/usr/bin/env sh
# testbox: title="hardcoded PI constant, default awk precision"
readonly PI=3.14159265359     #  La valeur approximative de π

echo "The cosine of pi/4 is: $(awk "BEGIN {print cos($PI/4)}")"
