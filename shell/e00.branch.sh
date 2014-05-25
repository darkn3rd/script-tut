#!/bin/sh
echo -n "Input a number: "; read Number
if [ $Number -gt 0 ]; then
  echo Number is greater than 0
elif [ $Number -lt 0 ]; then
  echo Number is less than 0
else
  echo Number is 0
fi