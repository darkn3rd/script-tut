# Puppet 

Puppet is a configuration management tool used to manage a fleet of servers. Puppet scripts called *manifests* use a propiertary Domain-Specific Language (DSL) to describe the desired state. 

## Resources

### Core Resources

| Core resource | Purpose                                           |
| ------------- | ------------------------------------------------- |
| `package`     | Install/manage software packages                  |
| `file`        | Files, directories, symlinks, permissions         |
| `service`     | Start/stop/enable services                        |
| `exec`        | Execute external commands                         |
| `user`        | User accounts                                     |
| `group`       | Groups                                            |
| `notify`      | Log messages                                      |
| `schedule`    | Control when resources may run                    |
| `tidy`        | Remove old/unwanted files                         |
| `filebucket`  | Backup/restore file contents                      |
| `resources`   | Manage/purge collections of another resource type |
| `stage`       | Catalog run-stage ordering                        |

### Package Providers

The `package` resource has the following providers:

| Provider            | Package system                 |
| ------------------- | ------------------------------ |
| `apt`               | Debian/Ubuntu APT              |
| `aptitude`          | Debian Aptitude                |
| `dpkg`              | Debian packages directly       |
| `dnf`               | Fedora/RHEL                    |
| `dnfmodule`         | DNF modules                    |
| `rpm`               | RPM directly                   |
| `pacman`            | Arch pacman                    |
| `gem`               | RubyGems                       |
| `pip`               | Python pip                     |
| `pip2`              | Python 2 pip                   |
| `pip3`              | Python 3 pip                   |
| `puppet_gem`        | Gems in Puppet's embedded Ruby |
| `puppetserver_gem`  | Gems for Puppet Server         |
| `portage`           | Gentoo                         |
| `freebsd` / `pkgng` | FreeBSD                        |
| `openbsd`           | OpenBSD                        |
| `macports`          | macOS MacPorts                 |
| `fink`              | macOS Fink                     |
| `windows`           | Windows MSI/EXE installers     |


### Bundled Resources

| Resource type        | Purpose                                                                                     | Typical platform / backend                             |
| -------------------- | ------------------------------------------------------------------------------------------- | ------------------------------------------------------ |
| `augeas`             | Modify structured configuration files using Augeas lenses without replacing the entire file | Linux/Unix; Augeas                                     |
| `cron`               | Manage cron jobs and crontab entries                                                        | Linux/Unix; cron                                       |
| `host`               | Manage static hostname/IP mappings                                                          | Linux/Unix/Windows; `/etc/hosts` or Windows hosts file |
| `mount`              | Manage filesystem mounts and persistent mount configuration                                 | Linux/Unix; `/etc/fstab`, mount                        |
| `scheduled_task`     | Manage Windows Task Scheduler jobs                                                          | Windows; Task Scheduler                                |
| `selboolean`         | Manage SELinux boolean settings                                                             | SELinux systems, especially RHEL/Fedora                |
| `selmodule`          | Install, remove, and manage SELinux policy modules                                          | SELinux systems                                        |
| `ssh_authorized_key` | Manage individual SSH public keys in users' `authorized_keys`                               | Linux/Unix; OpenSSH                                    |
| `sshkey`             | Manage SSH host keys, primarily entries in `known_hosts`                                    | Linux/Unix; OpenSSH                                    |
| `yumrepo`            | Manage YUM/DNF repo                                                                         |                                                        |


## Puppet Forge

The Puppet Platform supports a reporistory for the community built Puppet Modules called the Puppet Forge.

## Forge Modules Used

These are modules that are being currently evaluated:

* Version Managers
  * [rbenv](https://forge.puppet.com/modules/jdowning/rbenv) by Justin Downing (PDK)
  * [rvm](https://forge.puppet.com/modules/puppet/rvm/) by Vox Pupuli
  * [rustup](https://forge.puppet.com/modules/dp/rustup/) by Daniel Parks [PDK]
* Package Manager (System)
  * [chocolatey](https://forge.puppet.com/modules/puppetlabs/chocolatey/) by Puppet Labs (PDK)
  * [homebrew](https://forge.puppet.com/modules/thekevjames/homebrew) by Kevin James (PDK)
  * [apt](https://forge.puppet.com/modules/puppetlabs/apt/) by PuppetLabs (PDK)
* Language Modules
  * [pip](https://forge.puppet.com/modules/puppet/python/) by Vox Pupuli
  * [cpanm](https://forge.puppet.com/modules/puppet/cpanm/) by Vox Pupuli
* Windows
  * [windowsfeature](https://forge.puppet.com/modules/puppet/windowsfeature/) by Vox Pupuli
  * [powershell](https://forge.puppet.com/modules/puppetlabs/powershell/) by PuppetLabs (PDK)

## Archived or Not Maintained

* Version Manager
  * [puppet-pyenv](https://github.com/daenney/puppet-pyenv)
* Language Modules
  * [puppet-bundler](https://github.com/puppetlabs-operations/puppet-bundler)

## Missing Modules

* **Package Managers**: `pacman`, `cygwin`
* **Version Managers**: `asdf`, `sdkman`
* **Langauge Modules**: `gem`, PowerShell Gallery

## Links

* Puppet Open Source
  * [Puppet Bolt](https://github.com/puppetlabs/bolt) - remote execution
  * [r10k](https://github.com/puppetlabs/r10k) - puppet environment and module deployment
  * [puppet](https://github.com/puppetlabs/puppet)
  * [PDK](https://github.com/puppetlabs/pdk)
* Community Open Source Solutions
  * [OpenFact](https://docs.openvoxproject.org/openfact/latest/)
  * [OpenVox](https://docs.openvoxproject.org/openvox/latest/)
  * [OpenVoxServer](https://docs.openvoxproject.org/openvox-server/latest/)
  * [OpenVoxDB](https://docs.openvoxproject.org/openvoxdb/latest/)
  * [OpenBolt](https://docs.openvoxproject.org/openbolt/latest/)
  * [jig](https://github.com/voxpupuli/jig) - is a go-based reimplementation of PDK
    * [Scaffolding New Content with Jig](https://docs.openvoxproject.org/ecosystem/latest/devkit/jig.html)
    * [Migrating Away from the PDK](https://docs.openvoxproject.org/ecosystem/latest/devkit/migrating.html)
  * [g10k](https://github.com/voxpupuli/g10k) - go-based reimplementaiton of r10k
  * [Beaker](https://github.com/voxpupuli/beaker) - Puppet Acceptance Testing Harness 
* Other
  * [Vox Pupuli](https://voxpupuli.org/) - collective of Puppet module, tooling and documentation authors
  *  [Puppet’s Open Source Community Plans to Fork the Program](https://thenewstack.io/puppets-open-source-community-plans-to-fork-the-program/) 