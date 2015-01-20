# ConfigBox: Vagrant

© Joaquin Menchaca, 2014

## Overview

This area covers configuration of virtualized ScriptBox system using Vagrant.  These are steps for creating generic systems, can contains no provision system.

## Configuring Windows Systems

These steps are tested on Windows 7

### 1. Prerequisites

1. Install [VirtualBox](https://www.virtualbox.org/).
2. Install [Vagrant](https://www.vagrantup.com/downloads.html).

Note that Vagrant 1.6.5 is known to work well, while Vagrant 1.7.x has some known bugs that prevent these steps from working.

### 2. Download and Uncompress Image

These steps were ran using Mac OS X 10.8.5 using Virtual Box and Vagrant.  As Windows systems are huge, the compressed image may be around 3 GB to 4 GB.

1. Download Windows virtual system for VirtualBox from [Modern IE](https://www.modern.ie/en-us/virtualization-tools#downloads). Example: `IE10.Win7.For.Mac.VirtualBox.zip`

* Extract OVA file, e.g. `IE11 - Win10.ova`
* Import OVA file by double clicking on it, which creates new virtual system, e.g. `IE11 - Win10`
* Use Vagrant to package up a new system: `vagrant package --base "IE11 - Win10"`
* This will output a `package.box`, rename this to something like appropriate, such as `ie11-win10.box`


### 3. Configure Working Vagrant Directory

```Ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 1.6.2"
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "../../box/IE10_Win7.box"
  config.vm.hostname = "mybox"
  config.vm.communicator = "winrm"
  config.vm.network "forwarded_port", guest: 3389, host: 3389

  # Vagrant 1.6.x cannot detect Windows OS, thus need to set explicitly
  config.vm.guest = :windows

  config.vm.provider "virtualbox" do |vb|
    vb.gui = true  # break in case of emergency
    vb.customize ["modifyvm", :id, "--memory", "2048"]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end
end
```

### 4. Rename Account



1. Change User name from `IEUser` to `vagrant`
*  Change password from `Passw0rd!` to `vagrant`
*  Add password to `Administrator` with `vagrant`
* Install Virtual Box Guest Editions

### 5a. Configuring ScriptBox (Mingw + GNUWin32)

This configuration path is for supporting scripts that are run in the Windows Command Shell or PowerShell.  The scripting languages can use DOS paths like `C:\Ruby\ruby.exe`.

*  Install Bitvise SSH Server

### 5b. Configuring CygWin

This configuration path is for supporting scripts that are run in a simulated Unix environment using CygWin.  Tools within CygWin will work with Unix paths like `/c/Ruby/ruby`.
