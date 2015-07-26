# ConfigBox: Puppet with Hiera

© Joaquin Menchaca, 2015

## Overview

Puppet can configure a system using a tool called Hiera.  Hiera will uniquely configure your system based on a hierarchical structure of your own design.  For example, you can configure a system based on the *environment* (`development`, `staging`, `production`), followed by *role* (`web`, `database`, `message`), and then by *hostname*. In this demonstration, we keep is simple and use just the *hostname* (`db_shrdset01_slave01`, `db_shrdset02_master01`) as our hierarchy.  

Hiera can use a variety of backend systems to store these hierarchical configurations, such as YAML, JSON, SQL database, or LDAP.  For this demonstration, we use YAML files.

Reference: http://docs.puppetlabs.com/hiera/1/

# Provisioning Virtual Guest with Vagrant

In an ideal world, the puppet agent is configured to fetch configurations from a Puppet Master server, and then runs the scripts using `puppet agent`.  Vagrant can simulate similar behavior by running puppet locally and calling `puppet apply`.

The `Vagrantfile` is configured to mount appropriate directories for the main site manifest, `manifests/site.pp` and also the location of puppet modules `module`.  The site manifest in this scenario defers to Hiera system in order to acquire the configurations.

Reference: http://docs.vagrantup.com/v2/provisioning/puppet_apply.html
