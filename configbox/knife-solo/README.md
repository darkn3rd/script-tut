# ConfigBox: Knife-Solo

© Joaquin Menchaca, 2015

## Overview

Chef-Solo is a popular open source tool that allows running chef cookbooks without requiring access to a Chef Server.

According to documentation, the chef-solo does not support these features:

* Node data storage
* Search indexes
* Centralized distribution of cookbooks
* A centralized API that interacts with and integrates infrastructure components
* Authentication or authorization
* Persistent attributes

Reference: https://docs.chef.io/chef_solo.html

## Provisioning Virtual Guest Using Knife-Solo

The *Knife-Solo* tool will dynamically build a configuration file called `solo.rb` and a data file called `dna.json` based on the `nodes/hostname.json` datafile. This allows you to configure a system and desired cookbooks based on the hostname.  Knife-Solo will then run this command on the target system:

```bash
chef-solo -c solo.rb -j dna.json
```

***See***: [Knife Vagrant's ReadMe](vagrants-knife-solo/README.md)

Reference: http://matschaffer.github.io/knife-solo/
