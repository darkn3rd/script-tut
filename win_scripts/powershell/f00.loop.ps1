#!/usr/bin/env pwsh
# loop through complete listing with foreach
foreach($item in Get-ChildItem .\dirtest | Sort-Object) {
  if ($item.PsIsContainer) {          # test if object is directory
    "$($item.Name) is a directory"
  } else {
    "$($item.Name) is not a directory"
  }
}
