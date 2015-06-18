class scriptbox (
  $packages      = $scriptbox::params::packages,
) inherits scriptbox::params {

  if $operatingsystem == "ubuntu" {
    exec { 'apt_update':
      command   => "/usr/bin/apt-get update",
      logoutput => 'on_failure',
      before    => Package[$packages],
    }
  }

  package { $packages:    ensure => latest }
}
