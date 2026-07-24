#!/usr/bin/env tclsh
# testbox: title="glob with foreach collection"
# collection loop with output from Tcl's own glob command, without a
#  subshell - see f00.loop.tcl for the exec (`ls`) version of this lesson
foreach item [lsort [glob -directory dirtest -tails *]] {
   if {[file isdirectory "dirtest/$item"]} {
       puts "$item is a directory"
   } else {
       puts "$item is not a directory"
   }
}
