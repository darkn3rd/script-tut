# ConfigBox: Configuration Systems

© Joaquin Menchaca, 2015

**Last Update** July 27th, 2015

## Parts of Change

In my experience, I organized change into the following cognitive groups:

* System Activities
  * **Change Configuration** - changing a target system to a desired configuration state
  * **Change Coordination (Data Sharing)** - gathering information on one system, using this information to configure another system, such as configure web servers, then using this information to configure a load balancer or a monitoring server, which uses information from configuring the web servers.
* Application Activities
  * **Deployment** - deploying software (such as copying files) to a target system, usually a process launched from a continuous integration or continuous delivery system.  The output of a CI system is called an artifact, which can be a directory copied to the target system, or can be archived into an installable package, which can later be pulled down using the change configuration system.
  * **Orchestration** - coordinating which services needs to be suspended, such a database server with new schema or a message queue system with newly configured queues.  This way the web application uses updated external resources.   This can be also used to restart servers in an order, such as removing a configuration on the load balancer, so that the web server stops servicing new users, and once users have finished processing their current tasks, it can then be restarted with the new software, and reconnected to the load balancer.
* Ancillary Activities
  * **Reporting** - reporting on the status of changes, such as changes successfully made, not made, agents not responding or suspended, last change made, schedule changes.
  * **Inventory** - reporting on the systems and software themselves.

## Change Configuration Systems

This is an overview of change configuration systems and their differences.

System     | Type | Language | Scripts | Containers |  Code Base
---------- | -----| -------- | ------- | ---------- | ---------
Ansible    | push | yaml, ini | playbooks | roles | Python
CFEngine 3 | pull | cf   | promises | bundles | C
Chef       | pull | ruby, json | recipes | cookbooks | Ruby
Puppet 3   | pull | pp, yaml, json | manifests | modules | Ruby
Salt Stack | both | yaml | states | formulas | Python

### Key

* **System** Name of the system
* **Type** Whether the change is pushed onto the serve by remotely logging in, or whether an agent pulls the configuration from a server
* **Language** The language you need to use to create the scripts.  CFEngine and Puppet have their own proprietary DSL, and Chef uses class methods that mimic a DSL within Ruby.  Salt uses YAML to configure what they call states (SLS files).  Ansible uses YAML, but also an INI file to configure groupings of target systems.
* **Scripts** These are what the system calls their configuration scripts
* **Containers** Scripts can be organized into a some sort of, for lack of better terminology, container.  These are what the system calls these containers.
* **Code Base** This is the language the system is written in, and often times can be extended using the same language.

## Deployment Systems

Currently, I am not actively experimenting with these, but I have strong interests.  I identified the following systems that are heavily used in the industry:

* **Capistrano** - initially created to deploy code from a Rails environment, but was extended or adapted to support non-Rails environments.
* **Fabric** - python based deploy system
* **Mina** - a ruby based deploy system known for its speed.
* **MCollective** - solution popular in Puppet community and has heavy requirements (queue architecture)
* **Octopus** - system that is popular in .NET community

Additionally, both **Ansible** and **Salt Stack** have are push-oriented technologies and thus can be used to deploy code, such as copying source files and building assets, to a target system, and doing orchestration of multiple systems as well.
