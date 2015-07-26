# ConfigBox: Configuration Systems

© Joaquin Menchaca, 2015

**Last Update** July 27th, 2015

# Change Configuration Systems

This is an overview of change configuration systems and their differences.

System     | Type | Language | Scripts | Containers |  Code Base
---------- | -----| -------- | ------- | ---------- | ---------
Ansible    | push | yaml, ini | playbooks | roles | Python
CFEngine 3 | pull | cf   | promises | bundles | C
Chef       | pull | ruby, json | recipes | cookbooks | Ruby
Puppet 3   | pull | pp, yaml, json | manifests | modules | Ruby
Salt Stack | both | yaml | states | formulas | Python

## Key

* **System** Name of the system
* **Type** Whether the change is pushed onto the serve by remotely logging in, or whether an agent pulls the configuration from a server
* **Language** The language you need to use to create the scripts.  CFEngine and Puppet have their own proprietary DSL, and Chef uses class methods that mimic a DSL within Ruby.  Salt uses YAML to configure what they call states (SLS files).  Ansible uses YAML, but also an INIT file to configure groupings of target systems.
* **Scripts** These are what the system calls their configuration scripts
* **Containers** Scripts can be organized into a some sort of, for lack of better terminology, container.  These are what the system calls these containers.
* **Code Base** This is the language the system is written in, and often times can be extended using the same language.
