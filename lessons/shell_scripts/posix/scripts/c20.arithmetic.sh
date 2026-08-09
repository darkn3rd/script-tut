#!/usr/bin/env sh
# testbox: title="hardcoded PI constant"
readonly PI=3.14159265359     #  La valeur approximative de π
radius=3
# calculate area
area=$(echo "$PI * $radius ^ 2" | bc)
# output results
echo "The area of a circle (radius=$radius) is: $area."
