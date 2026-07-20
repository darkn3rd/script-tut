#!/usr/bin/env python
# declare some variables
pond     = 500 # pond contains some available fish
captured = 0   # captured represents fish capture
# utility variable, contains message for output
notice   = "Fishing from a local pond... We now have {} in the main pond."

# create subroutine called fish
def fish():
    global captured # explicitly declare we'll use global caputured
    pond      = 500 # must declare some number before subtracting from it

    pond     -= 150 # now subtract from local pond
    captured += 150 # add to the fish captured
    

# output intial amount of fish in shared resource    
print "We have {} in this pond.".format(pond)    

fish()                    # get some fish
print notice.format(pond) # output result

fish()                    # get some fish
print notice.format(pond) # output result

fish()                    # get some fish
print notice.format(pond) # output result

# output result of fish captured from local resource
print "We now have a total of {} fish captured".format(captured)