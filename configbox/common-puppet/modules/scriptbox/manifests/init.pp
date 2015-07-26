class scriptbox (
  $packages      = $scriptbox::params::packages,
) inherits scriptbox::params {

  # Tested on Precise (Ubuntu 12), Wheezy (Debian 7)
  if $osfamily == "Debian" {
    exec { 'apt_update':
      command   => "/usr/bin/apt-get update",
      logoutput => 'on_failure',
      before    => Package[$packages],
    }
  }

  package { $packages:    ensure => latest }
}
