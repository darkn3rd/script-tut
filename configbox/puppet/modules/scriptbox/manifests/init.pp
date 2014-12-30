class scriptbox (
  $shell_posix   = $scriptbox::params::shell_posix,
  $shell_bash    = $scriptbox::params::shell_bash,
  $shell_ksh     = $scriptbox::params::shell_ksh,
  $shell_csh     = $scriptbox::params::shell_csh,
  $script_awk    = $scriptbox::params::script_awk,
  $script_groovy = $scriptbox::params::script_groovy,
  $script_perl   = $scriptbox::params::script_perl,
  $script_php    = $scriptbox::params::script_php,
  $script_python = $scriptbox::params::script_python,
  $script_ruby   = $scriptbox::params::script_ruby,
  $script_tcl    = $scriptbox::params::script_tcl,
) inherits scriptbox::params {

  $shells    = [$shell_posix, $shell_bash, $shell_ksh, $shell_csh]
  $scripting = [$script_awk, $script_groovy, $script_perl, $script_php,
                $script_python, $script_ruby, $script_tcl]

  if ($operatingsystem == "ubuntu") {
    exec { 'apt_update':
      command => "/usr/bin/apt-get update",
      logoutput => 'on_failure',
      before => Package[$shells, $scripting],
    }
  }

  package { $shells:    ensure => latest }
  package { $scripting: ensure => latest }
}
