class system::windows inherits system {
  notify {"system = windows":}

  include component::java
  include component::groovy
  include component::gawk
  include component::perl
  include component::php
  include component::python
  include component::ruby
  include component::tcl
  include component::bash        # installs MSYS
  include component::posix       # installs UWIN
  include component::ksh         # installs UWIN
  include component::csh         # installs UWIN
  include component::wsh
  include component::powershell
}
