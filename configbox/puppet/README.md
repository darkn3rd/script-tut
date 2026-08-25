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

## Installing Forge Modules

The modules that you download will be vendored into `.forge-vendor`.  

### Installing a Single Module

Here is an example how you can install `puppetlabs-stdlib` requirement.

* PowerShell
  ```pwsh
  $RepoPath = Resolve-Path "..\.."
  $ForgeApi = "https://forgeapi.puppet.com"
  $Latest = (Invoke-RestMethod `
    "$ForgeApi/v3/modules/puppetlabs-stdlib").current_release.version

  # Install a single module using puppet command
  puppet module install puppetlabs-stdlib `
    --version $Latest `
    --target-dir $RepoPath/configbox/puppet/.forge-vendor

  # Install a single module directly using the Forge REST API
  Push-Location "$RepoPath\configbox\puppet\.forge-vendor"
  $ForgeApi = "https://forgeapi.puppet.com"
  $LatestFileUri = (Invoke-RestMethod `
    "$ForgeApi/v3/modules/puppetlabs-stdlib").current_release.file_uri
  
  # download
  Invoke-WebRequest -Uri "$ForgeApi$LatestFileUri" -OutFile stdlib.tar.gz
  tar -xzf stdlib.tar.gz
  Move-Item "puppetlabs-stdlib-$Latest" stdlib
  Remove-Item stdlib.tar.gz
  Pop-Location
  ```
* Bash
  ```bash
  REPO_PATH=$(realpath ../..)
  FORGE_API="https://forgeapi.puppet.com"
  LATEST="$(curl -s $FORGE_API/v3/modules/puppetlabs-stdlib \
    | jq -r '.current_release.version')"
    
  # Install a single module using puppet command
  puppet module install "puppetlabs-stdlib" \
    --version $LATEST \
    --target-dir $REPO_PATH/configbox/puppet/.forge-vendor
  
  # Install a single module directly using the Forge REST API
  pushd $REPO_PATH/configbox/puppet/.forge-vendor
  FORGE_API="https://forgeapi.puppet.com"
  LATEST_FILE_URI="$(curl -s $FORGE_API/v3/modules/puppetlabs-stdlib \
    | jq -r '.current_release.file_uri')"
    
  # download
  curl -sL -o stdlib.tar.gz "${FORGE_API}${LATEST_FILE_URI}"
  tar -xzf stdlib.tar.gz
  mv puppetlabs-stdlib-$LATEST stdlib
  rm stdlib.tar.gz
  popd
  ```

### Installing All Modules specified in Puppetfile

[r10k](https://github.com/puppetlabs/r10k) and [g10k](https://github.com/voxpupuli/g10k) can install the modules specified in the `Puppetfile`.  It will not install module's dependencies themselves.

* Powershell
  ```pwsh
  # Install all required modules using r10k
  # Note: this will not resolve module dependencies, only what's specified 
  #       in the Puppetfile. 
  gem install r10k
  r10k puppetfile install `
    -moduledir configbox\puppet\.forge-vendor `
    -puppetfile "$RepoPath\configbox\puppet\Puppetfile"
  ```
* Bash
  ```sh
  # Install all required modules using r10k
  # Note: this will not resolve module dependencies, only what is specified 
  #       in the Puppetfile.   
  gem install r10k
  r10k puppetfile install \
    -moduledir configbox/puppet/.forge-vendor \
    -puppetfile "$REPO_PATH/configbox/puppet/Puppetfile"
  ```

### Automatic Module Management

You can use [librarian-puppet](https://github.com/voxpupuli/librarian-puppet) to automtically install modules specified in Puppetfile, but also manage the module's dependencies as well.

```sh
REPO_PATH=$(realpath ../..)
cd "$REPO_PATH/configbox/puppet/"

# install librarian
gem install librarian-puppet

# setup
librarian-puppet config path .forge-vendor --local
librarian-puppet install
```


## Archived or Not Maintained

* Version Manager
  * [puppet-pyenv](https://github.com/daenney/puppet-pyenv)
* Language Modules
  * [puppet-bundler](https://github.com/puppetlabs-operations/puppet-bundler)

## Missing Modules

* **Package Managers**: `pacman`, `cygwin`
* **Version Managers**: `asdf`, `sdkman`
* **Langauge Modules**: `gem`, PowerShell Gallery

## Configbox Configuration Items

The `lessons` area (gen_scripts/shell_scripts/compiled_lang/win_scripts) is implemented once in `shared_modules/lessons` (classifier-agnostic - see its own `manifests/init.pp`; named `shared_modules`, not `modules`, so it sorts after `enc`/`hiera`/`node_defs` - it's the one thing all three classifier trees point at, not one of them) and fed by `scriptbox/scripts/generate_puppet.rb`.

No real deployment runs all three of Puppet's classifier methods at once, so the generator produces exactly one shape per invocation via `--classifier`:

```
scriptbox/scripts/generate_puppet.rb <config.yml> <out_path> [--classifier site|hiera|enc] [--select TAG,TAG] [--exclude TAG,TAG]
```

| `--classifier` | Output                                  | How the module gets its data                                          |
| -------------- | ---------------------------------------- | ----------------------------------------------------------------------- |
| `hiera` (default) | `hiera/data/lessons/<platform>.yaml`  | Automatic class-parameter lookup (`lessons::gen_scripts::steps`, ...) - data and code never touch. Puppet's own recommended default. |
| `enc`          | `enc/data/<platform>.yaml`               | An External Node Classifier (`enc/node_classifier.rb`, `node_terminus = exec`) prints a `classes:`/`parameters:` document per node at compile time - data is *pushed*, not looked up. |
| `site`         | `node_defs/manifests/nodes/<platform>.pp` | The full step data inlined as literal `class { 'lessons::...': steps => [...] }` declarations inside a generated `node '<platform>' { ... }` block - oldest/least idiomatic of the three, kept for parity/comparison. |

Hand-written knobs (`lessons::user`, the four area gates) live in `hiera/data/common.yaml` / `enc/data/common.yaml` - never touched by the generator.

## Addendum: Highlighting Errors

Here are some methods to match everything and highlight in place. 

* Bash + Grep
  ```bash
  vagrant provision 2>&1 | grep -i --color=always -E "error|$"
  ```
* Powershell 7.x
  ```pwsh
  # ForEach-Object Pipe 
  vagrant provision 2>&1 | ForEach-Object {
    if ($_ -match 'error') {
      $_ -replace '(?i)error', "`e[31m`$0`e[0m"
    } else {
      $_
    }
  }

  # ForEach-Object in Function
  function Show-Highlighted {
    param([string]$Pattern = 'error')
    $input | ForEach-Object {
      if ($_ -match $Pattern) {
        $_ -replace "(?i)($Pattern)", "`e[31m`$1`e[0m"
      } else {
        $_
      }
    }
  }

  vagrant provision 2>&1 | Show-Highlighted

  # Condensed Foreach-Object 
  vagrant provision 2>&1 `
    | % { $_ -replace '(?i)(error)', "`e[31m`$1`e[0m" }
  ```
* PowerShell 5.x safe
  ```pwsh
  vagrant provision 2>&1 `
    | % { $_ -replace '(?i)(error)', "$([char]27)[31m`$1$([char]27)[0m" }
  ```

For filtering in only the errors:

* Bash + Grep
  ```bash
  vagrant provision 2>&1 | grep -i --color=always error
  ```
* PowerShell 
  ```pwsh
  vagrant provision 2>&1 | Select-String -Pattern "error"
  ```


## Links

* Puppet Open Source
  * [Puppet Bolt](https://github.com/puppetlabs/bolt) - remote execution
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
  * [Beaker](https://github.com/voxpupuli/beaker) - Puppet Acceptance Testing Harness 
* Other
  * [Vox Pupuli](https://voxpupuli.org/) - collective of Puppet module, tooling and documentation authors
  *  [Puppet’s Open Source Community Plans to Fork the Program](https://thenewstack.io/puppets-open-source-community-plans-to-fork-the-program/) 

  * Module Dependencies
    * [The four ways to install Puppet modules](https://www.puppeteers.net/blog/the-four-ways-to-install-puppet-modules/) by Samuli Seppänen on April 13, 2021
    * [Installing and managing modules from the command line](https://www.puppet.com/docs/puppet/7/modules_installing.html)
    * Tools
      * [r10k](https://github.com/puppetlabs/r10k) - puppet environment and module deployment
      * [g10k](https://github.com/voxpupuli/g10k) - go-based reimplementaiton of r10k
      * [librarian-puppet](https://github.com/voxpupuli/librarian-puppet) - automatic dependency management