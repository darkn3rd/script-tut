#!/usr/bin/env awk -f

# create subroutine called fish
function fish() {
    pond -= 150     # subtract fish from global pond
    captured += 150 # add to the fish captured
}

BEGIN {
    # declare variables (all variables are global)
    pond     = 500 # pond contains some available fish
    captured = 0   # captured represents fish capture
    # utility variable, contains message for output
    notice   = "Fishing from the main pond... We now have %s in the main pond.\n"

    # output intial amount of fish in shared resource
    printf "We have %s in this pond.\n", pond

    fish()              # get some fish
    printf notice, pond # output result

    fish()              # get some fish
    printf notice, pond # output result

    fish()              # get some fish
    printf notice, pond # output result

    # output result of fish captured from shared resource
    printf "We now have a total of %s fish captured\n", captured
}
