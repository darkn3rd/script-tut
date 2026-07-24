#!/usr/bin/env tclsh
# testbox: requires=posix
# testbox: title="exec (ls) with foreach collection"
# collection loop with output from exec
foreach item [exec ls dirtest] {
   if {[file isdirectory "dirtest/$item"]} {
       puts "$item is a directory"
   } else {
       puts "$item is not a directory"
   }
}
