node mybox { include scriptbox }


# Puppet Cave-Man Config style
# ===================================
# These systems are named after their system. This is not ideal, but it is
# easiest to understand.
#
# Notes:
#  - Best Practices would be to put these in a module, and have a module
#  dynamically configure itself regardless of system.
# ===================================

node wheezybox {
  $shells   = ["dash", "bash", "ksh", "tcsh"]
  $script   = ["gawk", "perl", "python", "php5-cli", "ruby", "tcl8.5"]
  $packages = [$shells, $scripting]

  package { $packages: ensure => "installed"}


  #$script_groovy = "groovy"
}

node centos6box {
  $shells   = ["dash", "bash", "ksh", "tcsh"]
  $script   = ["gawk", "perl", "python", "php-cli", "ruby", "tcl"]
  $packages = [$shells, $scripting]

  package { $packages: ensure => "installed"}

  # Install OpenJDK for Rhino, Groovy, Etc.
  package { "java-1.8.0-openjdk-devel": ensure => "installed"}

  # GVM is complicated, and running gvmtool doesn't work in puppet-apply
  # https://github.com/jenkins-infra/puppet-groovy
  # https://github.com/paulosuzart/gvm

}
