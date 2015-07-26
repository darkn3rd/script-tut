# ConfigBox: CFEngine 3

© Joaquin Menchaca, 2015

## Overview

CFEngine is an powerful configuration management system that can be custom tailored to not only do change configuration, but also inventory and reporting.  It is a very flexible system, but with this flexibility comes complexity.


### Status

Currently, I am still experimenting with this system.  My initial goal is to get the system to work using the Vagrant provisioner, and then later attempt to build a system on top of CFEngine to select a unique configuration per hostname.

## Provisioning with Vagrant

Currently, Vagrant 1.6.x to 1.7.4 is broken for CFEngine on Debian systems.  I have opened an issue [#6006](https://github.com/mitchellh/vagrant/issues/6006#event-365523006) and submitted a pull request [#6007](https://github.com/mitchellh/vagrant/pull/6007) to address this issue, so it should appear in a near future version of Vagrant.  Otherwise, Vagrant seems to work fine on CentOS with the Vagrant provisioner.

In the mean time you can install CFEngine on your target guest virtual system through these instructions:

### Debian

As root:

```bash
wget -qO- https://cfengine.com/pub/gpg.key | apt-key add -
echo "deb http://cfengine.com/pub/apt/packages stable main" > /etc/apt/sources.list.d/cfengine-community.list
apt-get update
apt-get install cfengine-community
```

Reference: https://cfengine.com/product/community/cfengine-linux-distros/

### CentOS

As root:

```bash
rpm --import https://cfengine.com/pub/gpg.key
cat <<EOF> /etc/yum.repos.d/cfengine-community.repo
[cfengine-repository]
name=CFEngine
baseurl=http://cfengine.com/pub/yum/\$basearch
enabled=1
gpgcheck=1
EOF
yum -y install cfengine-community
```
