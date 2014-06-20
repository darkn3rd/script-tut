#!/bin/sh
printf "Input a number: "; read number
if [ $number -gt 0 ]; then
  echo number is greater than 0
elif [ $number -lt 0 ]; then
  echo number is less than 0
else
  echo number is 0
fi