# test_helper.rb - shared setup for every test/test_*.rb file. Just
#  requires the two scripts under test and starts Minitest - no fixture
#  data lives here, since resolve_order's own tests use small synthetic
#  manifests (isolate the mechanism from the real manifest's own
#  content drifting over time) while generate_install_script's own
#  README-scenario tests deliberately load the real one (see its own
#  file for why).
require 'minitest/autorun'
require_relative '../resolve_order'
require_relative '../generate_install_script'
