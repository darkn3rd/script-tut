# ConfigBox

© Joaquin Menchaca, 2015

## Overview

This area will have details about how to configure a system with all the scripting languages needed for this tutorial.

## Vagrant

Currently developing some Vagrant scripts for:
  * ***Wheezy (Debian 7)***
  * ***Precise (Ubuntu 12)***
  * ***CentOS 6***

I have had some success with ***Mac OS X*** and ***Windows*** systems, but holding off on these as they are more complicated and require special care for packages on those systems.

## Change Configuration Systems

These are the current systems I am working for this simple experiment.

### Puppet

There are numerous ways to configure Puppet. I am focusing on these two areas:

* **Puppet with Node Definitions** - uses main site manifests (`manifests/site.pp`)
* **Puppet with Hiera** - an alternative system to store configurations and parameters using YAML (or another datasource like JSON or LDAP)

### Chef

There are also numerous ways to configure a system with Chef as well.  I am focusing on these tools:

* **Chef-Solo**
  * Vagrant's Chef-Solo Provisioner
  * **Knife-Solo** as the provisioner
* **Chef-Client with Chef-Zero**

In my current research (as of Vagrant 1.7 and earlier), the Vagrant provionser labeled `chef-zero` does not really configure the system with using Chef-Zero.  Vagrant installs a ***Chef-Zero*** server, and then ignores the server and uses ***Chef-Solo*** to configure the system.  This had added quite a bit of confusion in the community.

To use ***Chef-Zero***, the provisioner has to use ***Chef-Client***, but the server is not a full robust Chef Server, but rather a limited in-memory server on the local machine called *Chef-Zero*.  
