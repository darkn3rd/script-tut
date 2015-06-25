# Vagrant Chef-Solo Vagrants

These are Vagrant Virtualbox systems that can be used with Vagrant's built-in Chef-Solo provisioner. This configuration with create a node based configuration, where information stored in `nodes/hostname.json` will be used to configure the system.

## Installation

To use these systems, just navigate to the desired directory and type `vagrant up`.  This may take a while, but will configure and install the system.

## Vagrant's Chef-Solo Provisioner

The built-in support for *Chef-Solo* is activated by either doing an initial `vagrant up` or after the system is running, doing a `vagrant provision`.  The `Vagrantfile` provided has all the needed magic to make this just work.

Below are some details about the configuration used.

### Simple Configuration

Vagrant Chef-Solo provisioner will create custom `solo.rb` for the configuration and `dna.json` for variables and run-list of recipes to execute.  These are built with setting specified in the `Vagrantfile`:

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

### Overcoming Limitations

The existing options for Vagrant's Chef-Solo provisioner are quite limited, can cannot configure a virtual guest based on its hostname.  These are one off configurations that are manually tedious to update and support.  

Below is a way to dynamically create the `dna.json` based on the hostname.  This depends on the names of systems in the `nodes/hostname.json` that match the hostname specified in `config.vm.hostname` variable in the `Vagrantfile`

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
