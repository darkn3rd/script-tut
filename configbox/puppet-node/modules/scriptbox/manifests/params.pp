class scriptbox::params {

  $rvm_install = false

  case $operatingsystem {
    ubuntu: {
      $shells   = ["dash", "bash", "ksh", "tcsh"]
      $script   = ["gawk", "perl", "python", "php5-cli", "ruby", "tcl8.5"]
      $packages = [$shells, $scripting]
    }
    centos: {
      $shells   = ["dash", "bash", "ksh", "tcsh"]
      $script   = ["gawk", "perl", "python", "php-cli", "ruby", "tcl"]
      $packages = [$shells, $scripting]
    }
    windows: {
      $shells        = undef
      $scripting     = undef
      $packages = [$shells, $scripting]
    }
    default: { fail("Unrecognized operating system for scriptbox") }
  }

}
