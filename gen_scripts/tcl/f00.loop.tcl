#!/usr/bin/env tclsh
# collection loop with output from exec
foreach item [exec ls dirtest] {
   if {[file isdirectory "dirtest/$item"]} {
       puts "$item is a directory"
   } else {
       puts "$item is not a directory"
   }
}
