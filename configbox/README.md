# ConfigBox Overview

© Joaquin Menchaca, 2015

**Last Update** July 26th, 2015

## Overview

This area will have details about how to configure a system with all the scripting languages needed for this tutorial.  There are the targeted tools and environments.  This area requires the **Vagrant** and **VirtualBox** to be installed on the host system.

### Purpose

The purpose of testing with a Vagrant environment is to simulate a distributed change configuration system for a particular single system.  With this knowledge, you can test your change configuration code locally on a sandbox, before pushing it out into a live production system.  

To achieve this feat, the system must be able to configure each system uniquely, based on hostname.  Though this level of configuration is not needed for configure a system to support scripting languages, it is needed for configuring a web server or a database server.  Thus I apply this pattern to all systems.

### Prerequisites

These need to be installed on the host system before using these tools:

* VirtualBox - https://www.virtualbox.org/wiki/Downloads
* Vagrant - https://www.vagrantup.com/downloads.html

### Supported Hosts

Vagrant is supported on ***Debian*** and ***Redhat*** Linux distributions, which include ***CentOS*** and ***Ubuntu***.  It is also supported on ***OS X*** and ***Windows***.

This has been tested from **OS X 10.8.5**

## Change Configuration Systems

I put some documentation together on change configuration systems and concepts:

* [Change Configuration Systems](CONFIGSYSTEMS.md)

## The Provisioners

There are different tools that can be used to provision a guest virtual system.

### Knife-Solo

Knife Solo is a great tool that simulates a real Chef environment that would exist with a Chef Server.  The tool will remotely control a system, and configure the system with chef-solo.  Knife Solo also dynamically builds the configuration based on the `nodes/{hostname}.json` configuration files.

### Test Kitchen

This is for future mention.  Test Kitchen is a great tool that can automate several vagrant systems.  Chef has incorporated this tool for testing chef environments, and it has been popular with Ansbile as well.  Feasibly, it can be used to test any change configuration tool.  This tool does not use Vagrant's built-in provisioners, and handles provisioning outside the vagrant system.

### Vagrant

Vagrant comes with some built-in provisioners that can be configured in the `Vagrantfile`.

The current provisioners tested are the following:

  * :snake: [Ansible](vagrant/ansible)
  * :gem: [Chef Solo](vagrant/chef-solo)
  * :page_with_curl: [CFEngine 3](vagrant/cfengine)
  * :gem: Puppet 3
    * [Puppet using Node Manifests](vagrant/puppet-node)
    * [Puppet using Hiera](vagrant/puppget-hiera-yaml)
  * :snake: Salt Stack (TBA)
