# iterate through listing by each item through foreach-object
Get-ChildItem | ForEach-Object { # pipe in listing, iterate through items
  if ($_.PsIsContainer) {        # test if default object is directory
    "$_ is directory"
  } else {
    "$_ is not directory"
  }
}
