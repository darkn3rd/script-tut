# Generic Host

This area will cover any providers that can operate similarly across Linux, macOS, and Windows.  Currently, the only provider that works for this is the Virtualbox provider.

## Vagrant Virtualbox Provider

* **[VirtualBox](https://developer.hashicorp.com/vagrant/docs/providers/virtualbox)** will work with Vritualbox 4.0.x to 7.2.x

## Virtualbox

**[Virtualbox](https://www.virtualbox.org/)** is supported on:

* **Windows** (Intel)
* **macOS** (Intel)
* **macOS** (Apple Silicon)
* **[Linux distriubtions](https://www.virtualbox.org/wiki/Linux_Downloads)** (Intel)
  * **Oracle Linux** (**RHEL**) 8, 9, 10
  * **Ubuntu** 22.04, 24.04, 25.04, 25.10, 26.04
  * **Debian** 11, 12, 13
  * **openSUSE** 15.6, 16.0
  * **Fedora** 40, 41, 42, 43, 44
* **Solaris** (Intel)

## Virtualbox Guests Images

* Ubuntu 22.04
    * [`generic/ubuntu2204`](https://portal.cloud.hashicorp.com/vagrant/discover/generic/ubuntu2204)
    * [`roboxes/ubuntu2204`](https://portal.cloud.hashicorp.com/vagrant/discover/roboxes/ubuntu2204)
    * [`bento/ubuntu-22.04`](https://portal.cloud.hashicorp.com/vagrant/discover/bento/ubuntu-22.04) 
* Windows 11
    * [`gusztavvargadr/windows-11`](https://portal.cloud.hashicorp.com/vagrant/discover/gusztavvargadr/windows-11)

## Box Builds 

* [Roboxes (Wayback Machne)](https://web.archive.org/web/20250217175531/https://roboxes.org/)
    * [Robox Source](https://github.com/lavabit/robox/)
* [Bento Project](https://github.com/chef/bento)
* [Boxcutter](https://github.com/boxcutter) - KVM images
* [Tim Sutton](https://github.com/timsutton/osx-vm-templates) - macOS X
* [Matt Wrock](https://github.com/mwrock/packer-templates) - Windows images
* [Gusztáv Varga](https://github.com/gusztavvargadr)

## Other

* https://aka.ms/windev_VM_virtualbox
* https://aka.ms/windev_VM_hyperv