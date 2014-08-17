#!/usr/bin/env pash
# loop through complete listing with foreach
foreach($item in Get-ChildItem) {    # cycle through directory listing
  if ($item.PsIsContainer) {          # test if object is directory
    "$item is directory"
  } else {
    "$item is not directory"
  }
}
