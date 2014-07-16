#!/usr/bin/python
# declare some variables
pond     = 500 # pond contains some available fish
captured = 0   # captured represents fish capture
# utility variable, contains message for output
notice   = "Fishing from the main pond... We now have {} in the main pond."

# create subroutine called fish
def fish():
    global pond     # explicitly declare we'll use global pond
    global captured # explicitly declare we'll use global captured
    
    pond -= 150     # subtract fish from global pond
    captured += 150 # add to the fish captured

# output intial amount of fish in shared resource    
print "We have {} in this pond.".format(pond)    

fish()                    # get some fish
print notice.format(pond) # output result

fish()                    # get some fish
print notice.format(pond) # output result

fish()                    # get some fish
print notice.format(pond) # output result

# output result of fish captured from shared resource
print "We now have a total of {} fish captured".format(captured)