# PackageBox

This area is for making and publishing packages that were needed by the script-tut repository and do not exist within public community repositories.

## Links

### General

* Homebrew
  * [Homebrew Formula Cookbook](https://docs.brew.sh/Formula-Cookbook)
  * Taps
      * [Taps](https://docs.brew.sh/Taps) - Third-pArty Repositories
      * [How to Create and Maintain a Tap](https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap)
  * [Homebrew Core](https://github.com/Homebrew/homebrew-core) - formulae
  * [Homebrew Cask](https://github.com/Homebrew/homebrew-cask) - default casks (upsteam binary packages)
* Chocolatey
  * [Chocolatey Community Repository](https://community.chocolatey.org/packages)
  * [Package Builder (C4B)](https://docs.chocolatey.org/en-us/features/package-builder/)
    * [Create Packages](https://docs.chocolatey.org/en-us/create/create-packages/)
  * [Chocolatey Automatic Package Updater Module](https://github.com/majkinetor/au) - archived in 2022
  * [David's Chocolatey Automatic Packages](https://github.com/flcdrg/au-packages)
  * [Chocolatey Automatic Package Updater Module](https://github.com/chocolatey-community/chocolatey-au)
  * [Chocolatey AU Action](https://github.com/chocolatey-community/chocolatey-au-action)
* Arch Linux
  * [AUR](https://wiki.archlinux.org/title/Arch_User_Repository)
  * [pkgbuild](https://wiki.archlinux.org/title/Creating_packages)
* [MSYS2 Packages](https://www.msys2.org/wiki/Creating-Packages/) 
* [Cygwin Packages](https://cygwin.com/packaging-contributors-guide.html)
* General
  * [Katello](https://github.com/katello/katello)
  * [Artifactory OSS Downloads Page](https://jfrog.com/community/open-source/)
  * [Nexus 3 OSS](https://github.com/ansible-ThoTeam/nexus3-oss) (Archived 7-2-2026)
    * https://github.com/CloudKrafter/nexus-ansible-collection
    * https://github.com/sonatype/nexus-public
* [Ansible Galaxy](https://galaxy.ansible.com/ui/)  
* [Chef Supermarket](https://github.com/chef/supermarket)


### Packagers

* [nFPM](https://nfpm.goreleaser.com/) - a simple `deb`, `rpm`, `apk`, `ipk`, `pacman`, and `msix` packager written in Go.
* [FPM (eFfing package management)](https://fpm.readthedocs.io/en/latest/) - packager written in Ruby that can make `deb`, `rpm`, `apk`, `pacman`, freebsd `pkg`, `osxpkg`, Solaris `p5p`, PHP `pear`, NetBSD `pkgsrc`, python PyPI, snap, Solaris SRV4, tar, zip, cpan, gem, npm.

### Publish Packages

* General
  * [Pulp](https://pulpproject.org/) - open source project that makes it easy for developers to fetch, upload, organize and distribute Software Packages on-prem or in the cloud.  It has a plugin architecture with plugins for RPM, Container Images (OCI), Ansible collections and roles, Debian (deb), Python PyPI, Maven (Java Jars), Ruby Gem.  There's also an unmaintained plugin for Chef Cookbooks. 

* Apt Repository
  * [reprepro](https://github.com/ionos-cloud/reprepro) - Debian package repository producer
    * [SetupWithReprepro](https://wiki.debian.org/DebianRepository/SetupWithReprepro)
  * [Aptly](https://www.aptly.info/) - Swiss army knife for Debian repository management
    * [aptly](https://github.com/aptly-dev/aptly) - Debian repository management tool

* RPM/YUM
  * [pulp_rpm plugin](https://pulpproject.org/pulp_rpm/docs/user/)
    * [pulp_rpm](https://github.com/pulp/pulp_rpm)