class scriptbox::groovy {
  include scriptbox::java

  # Ensure Curl Avialable
  package { "curl": ensure => "installed"}

  # Curl Doesn't Work FTM

  exec { 'gvm-install':
  command => '/usr/bin/curl -s get.gvmtool.net | bash',
  require => Package['curl'],
  unless  => "/usr/bin/test -e ~/.gvm/etc/config",
}

exec { "groovy-install":
command => "bash --login -c 'gvm install groovy'",
require => Exec['gvm-install'],
}

}
