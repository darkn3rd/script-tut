class scriptbox::params {

  $rvm_install = false

  case $osfamily {
   # Packages Tested on Ubuntu Precise
    Debian: {
      $shells   = ["dash", "bash", "ksh", "tcsh"]
      $script   = ["gawk", "perl", "python", "php5-cli", "ruby", "tcl8.5"]
    }
    # Package List tested CentOS 6.6
    RedHat: {
      $shells   = ["dash", "bash", "ksh", "tcsh"]
      $script   = ["gawk", "perl", "python", "php-cli", "ruby", "tcl"]
    }
    windows: {
      $shells     = undef
      $script     = undef
    }
    default: { fail("Unrecognized operating system for scriptbox") }
  }

  $packages = [$shells, $script]

}
