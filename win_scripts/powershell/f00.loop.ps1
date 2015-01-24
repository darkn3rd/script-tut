#!/usr/bin/env pash
# loop through complete listing with foreach
foreach($item in Get-ChildItem .\dirtest | Sort-Object) {
  if ($item.PsIsContainer) {          # test if object is directory
    "$item is a directory"
  } else {
    "$item is not a directory"
  }
}
