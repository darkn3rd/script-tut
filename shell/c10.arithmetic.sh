#!/bin/sh
readonly PI=3.1415927     #  La valeur approximative de π
radius=3
area=$(echo "$PI * $radius ^ 2" | bc)
 
echo $area