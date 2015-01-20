# Configuring Box

© Joaquin Menchaca, 2014

## Overview

As I wrap up documenting the exact configuration paths using a variety of environments, I wish to develop some automation scripts that could theoretically, from one command install all the needed components.

## Puppet and Vagrant

I am in the process (Dec 31, 2014) of creating some Puppet Modules called Scriptbox that can install the needed components for these scripting languages.  The idea is to have some scripts that run on Linux, then expand this to Mac OS X (Hoembrew or MacPorts) and then Windows (MSYS or CygWin and Chocolately).

I also created some sample Vagrant configuration files `Vagrantfile` that support Puppet and configuration settings.  These will be updated as I find tweaks and optimizations required for various environments.

## Status

I put this on hold to devise a strategy as it gets quite complex on platforms that do not have native package managers or native POSIX shell environments.

I devised an abstract model in Ruby to visualize how I might want to create components and such.

```Ruby
class Environment
    def initialize(ostype, pkgmgr = ostype, shell = ostype)
        # ...
    end
end

class Component
    def initialize(source = "package")
       self.source = source  # default: "package"
       self.method = method  # default: "package"
    end

    attr_accessor :source
end

class Java < Component
    def initialize(source, type = "oracle", version = "7")
        super(source)
        self.type = type       # oracle, openjdk
        self.version = version # 7, 8
    end

    attr_accessor :type, :version
end

class Groovy < Component
    def initialize(source, method = "gvm")
        super(source)
        self.method = method # package or gvm
    end

    attr_accessor :method
end

class Ruby < Component
    def initialize(source, method = "package")
        super(source)
        self.method = method # package or rvm
    end

    attr_accessor :method
end

class Perl < Component
    def initialize(source, type = "active")
        super(source)
        self.type = type # strawberry (WINDOWS ONLY), active
    end
    attr_accessor :type
end

class Posix
    def initialize(target)
      self.target = target # dash, ksh, ash, xpg, bash
    end
    attr_accessor :target
end
```



## Research

There are numerous tools that can be used for automation of configurations.  Here are but a few:

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
