#!/usr/bin/env tcsh
# collection loop on directly glob
foreach file (`ls dirtest`)
    if (-d "dirtest/$file") then
        echo "$file is a directory"
    else
        echo "$file is not a directory"
    endif
end
# ^ mandatory newline to end block
