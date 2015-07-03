# Puppet-Node Vagrants

These are Vagrant Virtualbox systems that can be used with Vagrant's build-in Puppet provisioner, which uses `puppet apply`.  This configuration uses a node based configuration where information is stored in a main site manifests, `manifests/site.pp`, that is used to configure a system.

## Installation

To use these systems, just navigate to the desired directory and type `vagrant up`.  This may take a while, but will configure and install the system.

## Vagrant's Puppet Provisioner

The built-in support for *Puppet* is activated by either doing an initial `vagrant up` or after the system is running, doing a `vagrant provision`.  The `Vagrantfile` provided has all the needed magic to make this just work.

Below are some details about the configuration used.

### Simple Configuration

Vagrant Puppet provisioner will need a path to the site manifest and any modules in the  `Vagrantfile`:

```ruby
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/some-linux-box"
  config.vm.hostname = "hostname-of-box"

  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "path/to/manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path    = ["path/to/modules"]
    puppet.options        = "--verbose --debug"
  end
end
```

By adding the paths, Vagrant will automatically share and mount these paths, and then refer to these paths when running `puppet apply`.
