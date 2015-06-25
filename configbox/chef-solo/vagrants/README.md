# Vagrant Provisioning

Vagrant has built in support for *Chef-Solo*, and once configured can be provisioned by typing `vagrant provsion`.  When you do this, Vagrant will run this command from within the virtual guest: `chef-solo -c /tmp/vagrant-chef/solo.rb -j /tmp/vagrant-chef/dna.json`

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
