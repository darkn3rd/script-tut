# ConfigBox: Chef-Solo

© Joaquin Menchaca, 2015

## Overview

Chef-Solo is a popular open source tool that allows running chef cookbooks with nodes without requiring access to a Chef Server.  The documentation online says that chef-client now supports a local mode, so this is not needed.  However, there is a lot of community support and usage, including vagrant.

According to documentation, the chef-solo does not support these features:

* Node data storage
* Search indexes
* Centralized distribution of cookbooks
* A centralized API that interacts with and integrates infrastructure components
* Authentication or authorization
* Persistent attributes

Reference: https://docs.chef.io/chef_solo.html

# Provisioning Virtual Guest

There are a few ways to provision a virtual guest using *Chef-Solo* solution.  There's Vagrant's built-in Chef-Solo provisioner, or a tool called *Knife-Solo*.  Ultimately these tools will call the following command on the virtual guest system:

```bash
chef-solo -c solo.rb -j dna.json
```

Each tool dynically creates these two files.

## Vagrant Provision

Vagrant has built in support for *Chef-Solo*, and will dynamically build required files (`solo.rb` and `dna.json`) based on settings in the `Vagrantfile`.

See: See: [Chef-Solo Vagrants ReadMe](vagrants/README.md)

Reference: http://docs.vagrantup.com/v2/provisioning/chef_solo.html

## Knife Solo Provision

Knife Solo remotely logs into the system, dynamically builds required files based (`solo.rb` and `dna.json`) on node configuration, i.e. `nodes/hostname.json`.

See: [Knife Vagrant's ReadMe](knife-vagrants/README.md)

Reference: http://matschaffer.github.io/knife-solo/
