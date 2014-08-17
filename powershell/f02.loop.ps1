#!/usr/bin/env pash
# iterate through listing using switch
switch (Get-ChildItem)  {
  $_.PsIsContainer {   "$_ is directory"  } 
  default          { "$_ is not directory" }
}