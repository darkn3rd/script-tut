#!/usr/bin/env pash
$radius=3                                  # set radius
$area=[Math]::pi * [Math]::Pow($radius, 2) # calculate area
"The area of a circle (radius=$radius) is: $area." # output result
