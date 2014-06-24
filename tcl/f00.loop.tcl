#!/usr/bin/tclsh
# collection loop with output from exec
foreach item [exec "ls"] {
   if {[file isdirectory $item]} {
       puts "$item is a directory."
   } else {
       puts "$item is not a directory."
   }
}
