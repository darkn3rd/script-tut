#!/usr/bin/env sh
printf "Input a number: "; read number
if [ $number -gt 0 ]; then
  echo Number is greater than 0
elif [ $number -lt 0 ]; then
  echo Number is less than 0
else
  echo Number is 0
fi
