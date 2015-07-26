# ConfigBox: Vagrant

© Joaquin Menchaca, 2015

**Last Update** July 26th, 2015

## Overview

This is how to configure a system using virtual system with target scripting languages using vagrant tool and built-in vagrant provisioner.

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

### Ansible

The scripts will apply the same configuration regardless of hostname.  As Ansible is a push technology, the hostname as well as SSH port address (which is random) needs to be configured in advance. I haven't yet found an eloquent solution to work around this limitation.

### Chef

For Chef configurations, the `:chef_solo` provisioner is used to configure the system.  Some custom Ruby code is used in the vagrant configuration to allow for customer configuration based on hostname.

### CFEngine

CFEngine poses a challenge as there are current bugs in Vagrant 1.7.4 that prevent CFEngine from functioning.  I have contributed a pull request to fix this.

I am still working on a strategy to support host based configuration.  In the mean time, the same configuration will be applied to all systems.

### Puppet

There are two examples for Puppet, one that uses **node manifests** and nother that uses **hiera** (yaml).
