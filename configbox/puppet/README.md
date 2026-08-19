# Puppet 

Puppet is a configuration management tool used to manage a fleet of servers. Puppet scripts called *manifests* use a propiertary Domain-Specific Language (DSL) to describe the desired state. 


# Puppet Forge

The Puppet Platform supports a reporistory for the community built Puppet Modules called the Puppet Forge.

## Forge Modules Used

These are modules that are being currently evaluated:

* Version Managers
  * [rbenv](https://forge.puppet.com/modules/jdowning/rbenv) by Justin Downing (PDK)
  * [rvm](https://forge.puppet.com/modules/puppet/rvm/) by Vox Pupuli
  * [rustup](https://forge.puppet.com/modules/dp/rustup/) by Daniel Parks [PDK]
* Package Manager (System)
  * [chocolatey](https://forge.puppet.com/modules/puppetlabs/chocolatey/) by Puppet Labs (PDK)
  * [homebrew](https://forge.puppet.com/modules/thekevjames/homebrew) by Kevin James (PDK)
  * [apt](https://forge.puppet.com/modules/puppetlabs/apt/) by PuppetLabs (PDK)
* Language Modules
  * [pip](https://forge.puppet.com/modules/puppet/python/) by Vox Pupuli
  * [cpanm](https://forge.puppet.com/modules/puppet/cpanm/) by Vox Pupuli
* Windows
  * [windowsfeature](https://forge.puppet.com/modules/puppet/windowsfeature/) by Vox Pupuli
  * [powershell](https://forge.puppet.com/modules/puppetlabs/powershell/) by PUppetLabs (PDK)

## Missing Modules

* **Package Managers**: `pacman`, `cygwin`
* **Version Managers**: `asdf`, `sdkman`
* **Langauge Modules**: `gem`
* **Other**: PowerShell Packages (Install-Module)

## Links

* Puppet Open Source
  * [Puppet Bolt](https://github.com/puppetlabs/bolt) - remote execution
  * [r10k](https://github.com/puppetlabs/r10k) - puppet environment and module deployment
  * [puppet](https://github.com/puppetlabs/puppet)
  * [PDK](https://github.com/puppetlabs/pdk)
* Community Open Source Solutions
  * [OpenFact](https://docs.openvoxproject.org/openfact/latest/)
  * [OpenVox](https://docs.openvoxproject.org/openvox/latest/)
  * [OpenVoxServer](https://docs.openvoxproject.org/openvox-server/latest/)
  * [OpenVoxDB](https://docs.openvoxproject.org/openvoxdb/latest/)
  * [OpenBolt](https://docs.openvoxproject.org/openbolt/latest/)
  * [jig](https://github.com/voxpupuli/jig) - is a go-based reimplementation of PDK
    * [Scaffolding New Content with Jig](https://docs.openvoxproject.org/ecosystem/latest/devkit/jig.html)
    * [Migrating Away from the PDK](https://docs.openvoxproject.org/ecosystem/latest/devkit/migrating.html)
  * [g10k](https://github.com/voxpupuli/g10k) - go-based reimplementaiton of r10k
  * [Beaker](https://github.com/voxpupuli/beaker) - Puppet Acceptance Testing Harness 
* Other
  * [Vox Pupuli](https://voxpupuli.org/) - collective of Puppet module, tooling and documentation authors
  *  [Puppet’s Open Source Community Plans to Fork the Program](https://thenewstack.io/puppets-open-source-community-plans-to-fork-the-program/) 