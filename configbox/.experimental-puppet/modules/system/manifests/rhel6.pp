class system::rhel6 inherits system {
  notify {"system = rhel6":}

  include component::java
  include component::groovy
  include component::gawk
  include component::perl
  include component::php
  include component::python
  include component::ruby
  include component::tcl
  include component::bash
  include component::posix
  include component::ksh
  include component::csh
}
