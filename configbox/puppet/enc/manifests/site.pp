# Hand-written, and deliberately near-empty - with node_terminus = exec
#  pointing at ../node_classifier.rb, Puppet already gets the `lessons`
#  class and every one of its parameters straight from the ENC's own
#  classes: block for every node; site.pp has no node classification
#  left to do. Kept only as the environment's required entry point.
node default { }
