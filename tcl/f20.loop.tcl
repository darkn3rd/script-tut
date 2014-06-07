#!/usr/bin/tclsh
# foreach construction /w exec
foreach item [exec "ls"] {
   if {[file isdirectory $item]} {
       puts "$item is a directory."
   } else {
       puts "$item is not a directory."
   }
}
