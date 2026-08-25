  test -x /opt/puppetlabs/bin/puppet && exit 0

  curl -sL https://apt.puppet.com/puppet8-release-jammy.deb \
    -o /tmp/puppet8-release.deb
    
  dpkg -i /tmp/puppet8-release.deb
  apt-get update
  apt-get install -y puppet-agent
  