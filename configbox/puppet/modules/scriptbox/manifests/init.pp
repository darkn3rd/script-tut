class scriptbox (
  $shells        = $scriptbox::params::shells,
  $scripting     = $scriptbox::params::scripting,
  $gvm_install   = $scriptbox::params::gvm_install,
) inherits scriptbox::params {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  if ($operatingsystem == "ubuntu") {
    exec { 'apt_update':
      command => "/usr/bin/apt-get update",
      logoutput => 'on_failure',
      before => Package[$shells, $scripting],
    }
  }

  package { $shells:    ensure => latest }
  package { $scripting: ensure => latest }

  if ($gvm_install == true) { include scriptbox::groovy }

}
