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

### External Provisioners

There are a number or external provisioners that may or may not be explored.  These include:

  * Platforms
    * ansible - outside of vagrant
    * salt - outside of vagrant
  * Tools 
    * [knife-solo](https://matschaffer.github.io/knife-solo/) for chef
    * [knife-zero](https://knife-zero.github.io/) for chef
    * [bolt](https://voxpupuli.org/blog/2025/12/17/openbolt-packages-available/) for puppet
    * [mcollective](https://github.com/Unity-Technologies/puppetlabs-mcollective) or [choria](https://choria.io)





