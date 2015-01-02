# Configuring Box: Vagrant-Puppet with Windows 7

© Joaquin Menchaca, 2014

## Overview

This is a basic Vagrant configuration for Windows 7 using Modern.IE's image.

## Instructions

In the initial configuration of this image, you need to do some preparation of the basic image so that is usable with Vagrant. You can do the following:

1. Enable GUI by uncommenting `vb.gui = true` in the `Vagrantfile`
* Create a account called Vagrant
* Add Vagrant to the Administrators group.
* Remove IEUser account.
* Change the public network to work network.
* Disable the Firewall (optional)
* Enable WinRM
* Configure WinRM with `AllowUnencrypted` and set `auth` to `Basic`
* Configure WinRM service to start on startup.
* Install Puppet Agent


### WinRM Configuration

The folk at Vagrant recommend this [setting](https://docs.vagrantup.com/v2/vagrantfile/winrm_settings.html):

```PowerShell
Set-Item WSMan:\localhost\Service\AllowUnencrypted -Value True
Set-Item WSMan:\localhost\Service\Auth\Basic -Value True
```

Also here's some other recommending [settings](https://github.com/WinRb/vagrant-windows#winrm-configuration) including the ones above:

```Batch
winrm quickconfig -q
winrm set winrm/config/winrs @{MaxMemoryPerShellMB="512"}
winrm set winrm/config @{MaxTimeoutms="1800000"}
winrm set winrm/config/service @{AllowUnencrypted="true"}
winrm set winrm/config/service/auth @{Basic="true"}
sc config WinRM start= auto
```

## Testing

### **Host Enviornment**
  * :dvd: Mac OS X 10.8.5 *Mountain Lion*
    * :package: VirtualBox 4.3.13
    * :package: Vagrant 1.6.3
    * :package: Microsoft® Remote Desktop Connection Client for Mac 2.1.1

### **Guest Environment**

  * :dvd: Windows 7 (32-bit) w. IE11
    * :package: Puppet 3.7.3 (32-bit)
