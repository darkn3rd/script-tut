# BuildBox

The area focuses on building systems that includes the following which include baking images, netboot, and bootstrap early-provisioners (kickstart, preseed, cloud-init).

The plan for this guide will be building images:

* Containers Images (OCI)
  * Docker 
  * [Packer](https://developer.hashicorp.com/packer)
* Virtual Machine Images
  * [Packer](https://developer.hashicorp.com/packer)

## Links

These are links that I have come across in this space.  As costs of IaaS go up and security threats are increasing, there's strong interest in building bespoke datacentres with baremetal and virtualization. Outside of this, docker imaging is ubiqutious for local development and cloud native with container orchestration.  

### Image Baking: Virtual Machine

* General 
    * [packer](https://developer.hashicorp.com/packer)
    * [mkosi](https://github.com/systemd/mkosi) — Build Bespoke OS Images
    * [KiwiNG](https://osinside.github.io/kiwi/)
    * [kiwi](https://github.com/osinside/kiwi)
    * [vagrant](https://developer.hashicorp.com/vagrant)
* Arch Linux
    * [Archiso](https://gitlab.archlinux.org/archlinux/archiso)
        * [Archiso Docs](https://wiki.archlinux.org/title/Archiso)
* Debian Linux
    * [Debootstrap](https://wiki.debian.org/Debootstrap)
* OpenSuSE Linux
    * [KIWI](https://github.com/coolo/kiwi)
* Hypervisor related
    * [libguestfs](https://libguestfs.org/)
    * [QEMU disk image utility](https://qemu-project.gitlab.io/qemu/tools/qemu-img.html)
    * [qemu-img for Windows](https://cloudbase.it/qemu-img-windows/)
        * [cloudbase/qemu](https://github.com/cloudbase/qemu)
    * [emu-img-windows-x64](https://github.com/fdcastel/qemu-img-windows-x64)
    * [vboxmanage](https://www.virtualbox.org/manual/ch08.html)
* Cloud
    * [aminator](https://github.com/Netflix/aminator)  
    * [EC2 Image Builder](https://aws.amazon.com/image-builder/)
    * [RedHat osbuild](https://osbuild.org/)

### Image Baking: Containers

* [packer](https://developer.hashicorp.com/packer)
* [buildpacks](https://buildpacks.io/)
* [ko](https://ko.build/) - easily build go containers
  * [ko](https://github.com/ko-build/ko) [github]
* [docker build](https://docs.docker.com/build/)
* [buildkit](https://github.com/moby/buildkit)
* [podman build](https://docs.podman.io/en/v5.5.2/markdown/podman-build.1.html)
* [Buildah](https://buildah.io/) 
* [kaniko](https://github.com/googlecontainertools/kaniko) [archived]
* [jib](https://github.com/googlecontainertools/jib) - build container images for java applications.  Plugins for Maven and Gradle. 

### Network Boot Firmware & Loaders

* [iPXE](https://ipxe.org/): open-source standard that allows systems to boot using reliable protocols like HTTP, iSCSI, or FCoE, instead of relying purely on TFTP. 
* [PXELINUX](https://wiki.syslinux.org/wiki/index.php?title=PXELINUX): part of syslinux suite, lightweight, classic choise used to boot Linux distributions via TFTP. 

### Ready-to-Use PXE Servers & Managers

* [iVentoy](https://www.iventoy.com/en/index.html): enhanced PXE/HTTPBoot server that uses ISO files. 
* [netboot.xyz](https://netboot.xyz/) - a small iPXE bootloader that opens to a menu of network installers, live distros, and rescue tools — fetched from upstream over the network, so there's no install media to manage.
* [bofied](https://github.com/pojntfx/bofied): a containerized network boot server. It wraps proxyDHCP, TFTP, and HTTP servers into a single tool featuring a clean web UI for managing boot 

### Full-Lifecycle Provisioning Suites

* [The Foreman](https://theforeman.org/) - a complete lifecycle management tool for physical and virtual servers. It handles orchestrating your DHCP/TFTP architecture to automatically spinning up systems using configuration management tools like Ansible or Puppet
* [FOG Project](https://fogproject.org/) - a free open-source network computer cloning and management solution

### Unattended Installation Engines

* [Kickstart](https://wiki.almalinux.org/documentation/kickstart-guide.html): RHEL, Fedora, Rocky
* [Cloud-Init](https://cloud-init.io/) / [Autoinstall](https://canonical-subiquity.readthedocs-hosted.com/en/latest/intro-to-autoinstall.html) 
* [Preseed](https://wiki.debian.org/DebianInstaller/Preseed): Debian-based installers

### Provisioning 

* [FAI (Fully Automatic Installation)](https://fai-project.org/) - FAI is a tool for unattended mass deployment of Linux. It is non-interactive deployment system used to configure and install Linux operating systems automatically
* [Cobbler](https://cobbler.github.io/)
  * [Cobbler QuickStart](https://cobbler.readthedocs.io/en/latest/quickstart-guide.html) - a Linux provisioning server that automates network-based OS installations using Kickstart
* [Canonical MAAS](https://canonical.com/maas) - MAAS is an open source platform that provides a centralized environment for managing and provisioning physical servers as if they were cloud resources
* [tinkerbell](https://tinkerbell.org/) - Standardize infrastructure management using the same API-centric, declarative configuration and automation approach
  * [Tinkerbell Getting Started](https://tinkerbell.org/docs/v0.22/setup/getting_started/)
* [OpenStack Ironic](https://docs.openstack.org/ironic/latest/) - provisions bare metal (as opposed to virtual) machines.
  * [Ironic Homepage](https://ironicbaremetal.org/)
  * [Ironic Source on GitHub](https://github.com/openstack/ironic)
  * [Ironic Source on OpenDev](https://opendev.org/openstack/ironic)


### Disk Imagers

* [Clonezilla](https://clonezilla.org/) 
* [SystemImager](https://sourceforge.net/projects/systemimager/)

# Links

* [Network booting tools](https://networkboot.org/tools/) - list of the programs that make network booting possible.
* [Top OS Imaging and Deployment Software: Enterprise Solutions for Mass Deployment ](https://zecurit.com/endpoint-management/os-imaging-deployment-software/)
* [Automated Patching Solutions Compared: 2026 Buyer's Guide](https://www.automox.com/blog/automated-patching-solutions-compared-2026)


