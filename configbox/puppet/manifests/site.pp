node mybox { include scriptbox }


# Very Basic Puppet Functionality

node wheezybox {
  $shells = ["dash", "bash", "ksh", "tcsh"]
  $scripting = ["gawk", "perl", "python", "php5-cli", "ruby", "tcl8.5"]
  $packages = [$shells, $scripting]

  package { $packages: ensure => "installed"}


  #$script_groovy = "groovy"
}

node centos6box {
  $shells = ["dash", "bash", "ksh", "tcsh"]
  $scripting = ["gawk", "perl", "python", "php-cli", "ruby", "tcl"]
  $packages = [$shells, $scripting]

  package { $packages: ensure => "installed"}
}
