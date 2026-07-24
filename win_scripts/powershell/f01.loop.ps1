#!/usr/bin/env pash
# iterate through listing by each item through foreach-object
Get-ChildItem .\dirtest | Sort-Object | ForEach-Object {
  if ($_.PsIsContainer) {        # test if default object is directory
    "$($_.Name) is a directory"
  } else {
    "$($_.Name) is not a directory"
  }
}
