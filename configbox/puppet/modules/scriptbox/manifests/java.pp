class scriptbox::java {
  ####### JAVA REQUIREMENTS #######
  package { java:
    name => $operatingsystem ? {
      "ubuntu"     => "openjdk-7-jre",
      "centos"     => "java-1.7.0-openjdk-devel"
      },
      ensure => "latest"
    }

    # Configure JAVA HOME
    file { "/etc/profile.d/java.sh":
    ensure  =>  'present',
    source  =>  'puppet:///modules/scriptbox/centos.java.sh',
    mode    =>  '0644',
    owner   =>  'root',
    require => Package['java'],
  }
}
