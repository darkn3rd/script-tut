#!/usr/bin/python

pond = 500
captured = 0

def fish():
    global captured # explicitly declare we'll use global caputured
    pond = 500      # must declare some number before subtracting
    pond -= 150     # now subtract from local pond
    captured += 150 # subtract 150 fish from global pond
    
    
print "We have {} in this pond.".format(pond)    

fish()  # get some fish
print "Fishing from a local pond... We now have {} in the main pond.".format(pond)

fish()  # get some fish
print "Fishing from a local pond... We now have {} in the main pond.".format(pond)

fish()  # get some fish
print "Fishing from a local pond... We now have {} in the main pond.".format(pond)

print "We now have a total of {} fish".format(captured)