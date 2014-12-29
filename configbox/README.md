# Configuring Box

© Joaquin Menchaca, 2014

## Overview

As I wrap up documenting the exact configuration paths using a variety of environments, I wish to develop some automation scripts that could theoretically, from one command install all the needed components.

There are numerous tools that can be used to automation configurations.  Here are but a few:

* Build-Tasks Tools (ala bugglegum & scripts mode)
  * [Cake](http://coffeescript.org/documentation/docs/cake.html) - CoffeeScript based
  * [Gradle](http://www.gradle.org/) - Groovy based
  * [Grunt](http://gruntjs.com/) - Node based
  * [Psake](https://github.com/psake/psake) - PowerShell based
  * [Rake](https://github.com/ruby/rake) - Ruby based
  * [SCons](http://scons.org/) - Python based
* Deployment & Orchestrate Tools
  * [Mina](http://nadarei.co/mina/) - requires Ruby
  * [Capistrano 3](http://capistranorb.com/) - requires Ruby
  * [Fabric](http://www.fabfile.org/) - requires Python
  * [Octopus](http://octopusdeploy.com/) - requires .NET
  * [MCollective](https://puppetlabs.com/mcollective) - requires advanced infrastructure
* Change Configuration Automation Tools
  * [Ansible](http://www.ansible.com/) - requires SSH
  * [Chef](https://www.chef.io/) - requires Chef agent
  * [CFEngine](http://cfengine.com/)
  * [Docker](https://www.docker.com/) - Linux only (containers)
  * [Puppet](https://puppetlabs.com/) - requires Pupet agent
  * [Salt Stack](http://www.saltstack.com/) - requires SSH
  * [Rocket](https://github.com/coreos/rocket) - Linux only (containers)
