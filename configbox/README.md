# ConfigBox

© Joaquin Menchaca, 2015

**Last Update** July 3rd, 2015

## Overview

This area will have details about how to configure a system with all the scripting languages needed for this tutorial.

## Vagrant

Currently developing some Vagrant scripts for:
  * ***Wheezy (Debian 7)***
  * ***Precise (Ubuntu 12)***
  * ***CentOS 6***

These scripts only support simple package installations for now

I have had some success with ***Mac OS X*** and ***Windows*** systems, but holding off on these as they are more complicated and require special care for packages on those systems.

I would like to support language specific version managers (gvm, rvm, rbenv) and groovy with Java depenency.


## Change Configuration Systems

These are the current systems I am working for this simple experiment.

### Puppet

There are numerous ways to configure Puppet. I am focusing on these two areas:

* **Puppet with Node Definitions** - uses main site manifests (`manifests/site.pp`)
* **Puppet with Hiera** - an alternative system to store configurations and parameters using YAML (or another datasource like JSON or LDAP)

Both of these I have used using the Vagrant's puppet provisioner.

### Chef

There are also numerous ways to configure a system with Chef as well.  I am focusing on these tools:

* **Chef-Solo**
  * Vagrant's `chef_solo` Provisioner
  * **Knife-Solo** as the provisioner
* **Chef-Client** with **Chef-Zero**
* **Chef-Client** with **Chef Server**

I was able to have node based configuration (using hostname) with Vagrant's Chef-Solo provisioner, and Knife-Solo tool.  Both remotely log into the system and run `chef solo`.
