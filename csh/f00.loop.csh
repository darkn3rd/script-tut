#!/bin/tcsh
# collection loop on directly glob
foreach file (*)
    if (-d $file) then
        echo "$file is a directory"
    else
        echo "$file is not a directory"
    endif
end
# ^ mandatory newline to end block