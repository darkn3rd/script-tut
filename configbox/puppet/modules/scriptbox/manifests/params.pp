class scriptbox::params {
  case $operatingsystem {
    ubuntu: {
      $shell_posix   = "dash"
      $shell_bash    = "bash"
      $shell_ksh     = "ksh"
      $shell_csh     = "tcsh"
      $script_awk    = "gawk"
      $script_groovy = "groovy"
      $script_perl   = "perl"
      $script_python = "python"
      $script_php    = "php5-cli"
      $script_ruby   = "ruby"
      $script_tcl    = "tcl8.5"
    }
    default: { fail("Unrecognized operating system for scriptbox") }
  }

}
