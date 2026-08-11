# ConfigBox: Puppet with Node Definitions

© Joaquin Menchaca, 2015

## Overview

Puppet Node Definitions (abbreviated as Puppet-Node) is the default system of Puppet.  It works in concert with `node` definitions in the main site manifest (`site.pp`).

A puppet agent is installed on the target system, which runs Puppet scripts, called manifests, written in Puppet DSL (`.pp` files).  The main site manifest describes the systems to be configured and which modules are installed on those specific systems.

In this demo system, there's a module `scriptbox`, which will be installed by a particular node.  Each node is defined by its host name (or a regular expression matching several hosts).

Reference: https://docs.puppetlabs.com/pe/latest/puppet_assign_configurations.html

# Provisioning Virtual Guest with Vagrant

In an ideal world, the puppet agent is configured to fetch configurations from a Puppet Master server, and then runs the scripts using `puppet agent`.  Vagrant can simulate similar behavior by running puppet locally and calling `puppet apply`.

The `Vagrantfile` is configured to mount appropriate directories for the main site manifest, `manifests/site.pp` and also the location of puppet modules `module`.

Reference: http://docs.vagrantup.com/v2/provisioning/puppet_apply.html
