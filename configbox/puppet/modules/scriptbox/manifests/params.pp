class scriptbox::params {

  $rvm_install = false

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
      $shells = [$shell_posix, $shell_bash, $shell_ksh, $shell_csh]
      $scripting = [$script_awk, $script_groovy, $script_perl, $script_php,
      $script_python, $script_ruby, $script_tcl]
      $gvm_install = false

    }
    centos: {
      $shell_posix   = "dash"
      $shell_bash    = "bash"
      $shell_ksh     = "ksh"
      $shell_csh     = "tcsh"
      $script_awk    = "gawk"
      $script_perl   = "perl"
      $script_python = "python"
      $script_php    = "php-cli"
      $script_ruby   = "ruby"
      $script_tcl    = "tcl"
      $shells = [$shell_posix, $shell_bash, $shell_ksh, $shell_csh]
      $scripting = [$script_awk, $script_perl, $script_php,
      $script_python, $script_ruby, $script_tcl]
      $gvm_install   = true
    }
    default: { fail("Unrecognized operating system for scriptbox") }
  }

}
