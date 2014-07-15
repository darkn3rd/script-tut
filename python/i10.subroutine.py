#!/usr/bin/python

pond = 500
captured = 0

# declare a fish method
def fish():
    global pond     # explicitly declare we'll use global pond
    global captured # explicitly declare we'll use global caputured
    pond -= 150     # subtract 150 fish from global pond
    captured += 150 # subtract 150 fish from global pond
    
print "We have {} in this pond.".format(pond)    

fish()  # get some fish
print "Fishing from the main pond... We now have {} in the main pond.".format(pond)

fish()  # get some fish
print "Fishing from the main pond... We now have {} in the main pond.".format(pond)

fish()  # get some fish
print "Fishing from the main pond... We now have {} in the main pond.".format(pond)

print "We now have a total of {} fish".format(captured)