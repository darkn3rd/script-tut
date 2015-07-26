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

## Provisioning Virtual Guest Using Vagrant

Vagrant has built in support for *Chef-Solo*, and will dynamically build required files (`solo.rb` configuration file and `dna.json` data file) based on settings in the `Vagrantfile`.  One these files are constructed, then Vagrant will run the following:

```bash
chef-solo -c solo.rb -j dna.json
```

This provisioner (`chef_solo`) is unfortunately quite limited, in that it does not support the node configuration, such as `nodes/myhost.json`.  For this, there's some popular hack using Ruby in the Vagrantfile to get this functionality.

***See***: [Chef-Solo Vagrants ReadMe](vagrants-vagrant-chef-solo/README.md)

Reference: http://docs.vagrantup.com/v2/provisioning/chef_solo.html
