# ConfigBox Overview

© Joaquin Menchaca, 2015-2026

## Overview

This section details how to configure a system for the languages used in this tutorial. The automation will be tested in a segregated environment, such as a virtual machine or container.The automation itself will use change configuration¹ SPACE² platforms or my own Scriptbox **bubblegum and scripts**.

¹ **change configuration** is also called [SCM](https://wikipedia.org/wiki/Software_configuration_management), [SCCM](https://wikipedia.org/wiki/Software_configuration_management), [NCCM](https://grokipedia.com/page/network_configuration_and_change_management), or [CM](https://grokipedia.com/page/Configuration_management)
² **SPACE** platforms are [**S**alt](https://saltproject.io/), [**P**uppet](https://www.puppet.com/), [**A**nsible](https://docs.ansible.com/), [**C**hef](https://www.chef.io/), [cf**E**ngine](https://cfengine.com/). Open Source Puppet and Chef with [OpenVox](https://voxpupuli.org/openvox/) and [CINC](https://cinc.sh/) are included. 

## Purpose

The purpose of testing in isolated environmets with Vagrant is to simulate a change management system for a single system.  Using this knowledge, you can test locally on a sandbox before using it elsewhere. 

In order to test using these languages quickly across different operating systems and distros.  The patterns used in configbox can be used to provision more advance scenarios, such as stateful server applications.

## Minimal Requirements

These need to be installed on the host system before using these tools:

* Automation:
  * **Vagrant** - https://www.vagrantup.com/downloads.html
* Provider
  * **VirtualBox** - https://www.virtualbox.org/wiki/Downloads

## Supported Systems

This can be tested easily on Intel-based macOS, Windows, and Linux hosts using Virtualbox. 

The following guests will be tested: 

 * Ubuntu 22.04

## Change Configuration Solutions 

Platform   | Type | Language       | Scripts   | Compoonents | Artifact Repository
---------- | -----| -------------- | --------- | ----------  | ---------------
Ansible    | push | yaml, ini      | playbooks | roles       | Galaxy
CFEngine   | pull | cf             | promises  | bundles     | —
Chef       | pull | ruby, json     | recipes   | cookbooks   | Supermarket
Puppet     | pull | pp, yaml, json | manifests | modules     | Forge
Salt Stack | both | sls (yaml), j2 | states    | formulas    | —

**Column Key**

* **Platform** - name of platform
* **Type** - push remote execution or agent pull
* **Langauge** - the language you need to use to create the scripts. CFEngine and Puppet have their own proprietary DSL, and Chef uses class methods that mimic a DSL within Ruby. Salt uses YAML to configure what they call states (SLS files). Ansible uses YAML, but also an INI file to configure groupings of target systems.
* **Scripts** - what the platform calls their scripts
* **Components** - scripts can be organized into a compoents for higher reusability. 
* **Artifact Repository** - remote repository to share resuable components developed by the community.  

## The Provisioners

Vagrant has automation to provision a virtual machine or container using one of the SPACE platforms for Shell.

### Vagrant Provisioners

These are the provisioners that are explored.  Any provider that requires a server to be set up will not be used due to complexity level required for simple automation.

* Ansible 
  * Ansible (`ansible`) - ansible run on host to configure the guest
  * Ansible Local (`ansible_local`) - ansible only run on the guest locally
* CFEngine (`cfengine`)
* Chef
  * Chef Solo (`chef_solo`)
  * Chef Zero (`chef_zero`)
* Puppet Apply (`puppet`)
* Salt (`salt`)
* Shell (`shell`)

### External Provisioners

There are a number or external provisioners that may or may not be explored.  These are just listed here for informational purposes.

**Platforms**

Some of the change configuration platforms have remote execution capabilities, so can provision virtual guests from the host.

* [ansible](https://github.com/ansible/ansible) - outside of vagrant
* [salt](https://github.com/saltstack/salt) - outside of vagrant

**Platform Tools**

There are tools built within the community that can facility boostrapping a system, i.e. installing the agent, as well as running convergence (configuring) the sytsem. 

  * [knife-solo](https://matschaffer.github.io/knife-solo/) for chef
  * [knife-zero](https://knife-zero.github.io/) for chef
    * [Use cinc-client instead?](https://knife-zero.github.io/tips/use_cinc-client_instead/) can install [cinc-client](https://cinc.sh/docs/client/) instead 
  * [bolt](https://voxpupuli.org/blog/2025/12/17/openbolt-packages-available/) for puppet
  * [mcollective](https://github.com/Unity-Technologies/puppetlabs-mcollective) or [choria](https://choria.io)

**General Remote Execution**

These are general purpose remote execution tools used to distrribute build artifacts on a target system and do some remote execution.  These could possible be used for any change configuration platform.

  * **[Capistrano](https://capistranorb.com/)** - initially created to deploy code from a Rails environment, but was extended or adapted to support non-Rails environments.
  * **[Mina](https://github.com/mina-deploy/mina)** ([docs](https://mina-deploy.github.io/mina/)) - a ruby based deploy system known for its speed.
  * **[Fabric](https://www.fabfile.org/)** - python based deploy system
  * **[TestKitchen](https://kitchen.ci/)** - is a test harness that can provision systems using chef or shell and test them using Inspec, ServerSpec, or BATS.  It also supports providers outside of Vagrrant managed providers, which include Azure, AWS, and GCP.
    * **[kitchen-ansible](https://github.com/neillturner/kitchen-ansible)** - ansible provisioner for TestKitchen
    * **[kitchen-cfengine](https://github.com/nmische/kitchen-cfengine/)** - cfengine provisioner for TestKitchen
    * **[kitchen-puppet](https://github.com/neillturner/kitchen-puppet)** - puppet provisioner for TestKitchen
    * **[kitchen-salt](https://github.com/saltstack/kitchen-salt)** - salt provisioner for TestKitchen

A site tracking these types of tools is found at [Amazing Deployment](https://github.com/delirehberi/amazing-deployment).

**Transports**

Any system can use custom scripts to connect a system using WinRM for Windows or OpenSSH for macOS and Linux. 
  
  * **[WinRM (Windows Remote Management)](https://learn.microsoft.com/windows/win32/winrm/portal)** - Microsoft's protocol for running commands and managing Windows systems remotely. It uses Simple Object Access Protocol (SOAP) over HTTP (port `5985`) or HTTPS (port `5986`)
  * **[OpenSSH](https://www.openssh.org/)**

## Future Ideas 

### Consul

Consul is more suitable for robust distributed architectures (pre-Kubernetes) that need service discovery and a key-value stores.  Configuration could be stored on such a system, and then fetched by a consul agent.  For a single system, it doesn't make much sense to use Consul.  This information is for informational purposes only.

* [consul-template](https://github.com/hashicorp/consul-template): can render templates locally, such as a configuration manifests used to install an application.  There would need to be another tool that interacts with such a solution to perform an convergence beyond configuration files.
* [ohai-plugin-consul](https://github.com/fujiwara/ohai-plugin-consul): this plugin extends [ohai](https://github.com/chef/ohai) to query consul and return json blobs for use with Chef configuration.
* [hiera-consul](https://github.com/lynxman/hiera-consul): allows to write to the k/v store for metadata centralization and harmonization.

Additionally, change configuration platforms may have solutions to build inventory or data dynamically, that can be used with consul or another solution: 

* Ansible [dynamic inventory](https://docs.ansible.com/projects/ansible/latest/inventory_guide/intro_dynamic_inventory.html)
* Salt
  * [External Pillars](https://docs.saltproject.io/en/3006/topics/development/modules/external_pillars.html)
  * [Using a Pillar Roster](https://salt-sproxy.readthedocs.io/en/latest/examples/pillar_roster.html)
  * [Ansible Roster Module](https://docs.saltproject.io/en/master/ref/roster/all/salt.roster.ansible.html)
* Puppet [External node classifiers](https://help.puppet.com/core/current/Content/PuppetCore/nodes_external.htm#Externalnodeclassifiers) (ENC)
  * [ENC output format](https://help.puppet.com/core/current/Content/PuppetCore/enc_output_format.htm)
