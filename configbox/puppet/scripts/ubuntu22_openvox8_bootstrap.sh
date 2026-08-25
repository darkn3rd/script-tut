test -x /opt/puppetlabs/bin/puppet && exit 0

curl -fsSL \
  https://apt.voxpupuli.org/openvox8-release-ubuntu22.04.deb \
  -o /tmp/openvox8-release.deb

dpkg -i /tmp/openvox8-release.deb
apt-get update
apt-get install -y openvox-agent
