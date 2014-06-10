#!/bin/awk -f
BEGIN {
  # declare variables    
  num    = 5
  char   = "a"
  string = "This is a string"
  
  # output values using string interpolation 
  printf "Number is  %d.\n", num
  printf "Character is '%c'.\n", char
  printf "String is \"%s\".\n", string
}
