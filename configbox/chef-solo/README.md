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

There are a few ways to provision a virtual guest using Chef-Solo solution.

## Vagrant Provision

Vagrant has built in support for Chef-Solo, and once configured can be provisioned by typing `vagrant provsion`.  When you do this, Vagrant will run this command from within the virtual guest: `chef-solo -c /tmp/vagrant-chef/solo.rb -j /tmp/vagrant-chef/dna.json`

In using this method, the `Vagrantfile` must configured appropriately to work:

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/some-linux-box"
  config.vm.hostname = "hostname-of-box"

  config.vm.provision ::chef_solo do |chef|
    chef.cookbooks_path  = ["path/to/cookbooks", "path/to//site-cookbooks"]
    chef.roles_path      = "path/to/roles"
    chef.data_bags_path  = "path/to/data_bags"
    chef.verbose_logging = true

    # Build Run-List
    chef.add_recipe = "some_recipe"
  end
end
```

By adding the paths, Vagrant will automatically share and mount these paths, and then create a custom `solo.rb` to refer to these mounted paths.

Reference: http://docs.vagrantup.com/v2/provisioning/chef_solo.html

### Limitations

As some might realize that this may seem quite limited.  You cannot configure code dynamically by the node for different hostnames, or can you?

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "chef/some-linux-box"
  config.vm.hostname = "hostname-of-box"

  VAGRANT_JSON = JSON.parse(Pathname(__FILE__).dirname.join('path/to/nodes', "#{config.vm.hostname}.json").read)

  config.vm.provision ::chef_solo do |chef|
    chef.cookbooks_path  = ["path/to/cookbooks", "path/to//site-cookbooks"]
    chef.roles_path      = "path/to/roles"
    chef.data_bags_path  = "path/to/data_bags"
    chef.verbose_logging = true

    # Build Run-List and Custom JSON Attributes
    chef.run_list = VAGRANT_JSON.delete('run_list') if VAGRANT_JSON['run_list']
    chef.json = VAGRANT_JSON
  end
end  
```

This is not the most attractive method, but it can dynamically build a custom `dna.json` based on the on your `node/hostname.json` file.

## Knife Solo

The Vagrants Chef-Solo provisioner may seem quite, well, cumbersome.  As an alternative, you can skip Vagrant's provisioning and use `knife solo` to provision the system.  This tool will remotely log into the virtual guest through ssh, and then run chef-solo.

**IMPORTANT** You must comment out the `config.vm.provision...end` block as Vagrant will automatically provision at startup with `vagrant up`.  The Vagrant provisioner must be commented if you wish to use knife-solo as the provisioner.

To install this tool, type `bundle` within this directory, and it will use the `Gemfile` to install `knife-solo`.  Note that an existing Ruby environment should be in place along with the bundler tool (`gem install bundler`).

After installing knife-solo, install chef-solo on the guest system:

`knife solo prepare vagrant@127.0.0.1 -p 2222 -i .vagrant/machines/default/virtualbox/private_key`

Then to provision the system run this command:

`knife solo cook vagrant@127.0.0.1 -p 2222 -i .vagrant/machines/default/virtualbox/private_key`

Reference: http://matschaffer.github.io/knife-solo/
