# Ansible

Ansible is an agentless configuration management and automation tool that manages fleets of systems using infrastructure-as-code (IaC) documents called playbooks.  Playbooks are written in YAML and describe tasks used to bring systems into a desired state.

Ansible is primarily a push-based and agentless configuration management system. Playbooks are executed from a control node called a workstation, which connects to managed systems remotely, commonly using SSH for Unix/Linux systems and WinRM or SSH for Windows. Ansible can gather facts about managed systems and use that information to dynamically determine how individual systems or groups of systems should be configured.

Ansible is also widely used to configure network devices, where installing an agent on the managed device is often impractical or impossible. Its agentless, remote-execution architecture makes it particularly well suited to network automation.

In addition to operating-system configuration, Ansible can provision and manage cloud infrastructure on platforms such as AWS, Microsoft Azure, and Google Cloud. Collections and modules are also available for managing Kubernetes resources and many applications and services that expose REST APIs. This allows the same Ansible automation model to be used across operating systems, network devices, cloud infrastructure, and application platforms.

## Ansible Built-in Modules

Ansible modules are units of code used to manage system resources or execute operations on managed hosts. Modules included with `ansible-core` use the `ansible.builtin` namespace.

### Package Management

| Module            | Description                          |
| ----------------- | ------------------------------------ |
| `package`         | Generic OS package management        |
| `package_facts`   | Gather installed package information |
| `apt`             | Manage APT packages                  |
| `dnf`             | Manage DNF packages                  |
| `dnf5`            | Manage packages using DNF5           |
| `dpkg_selections` | Manage dpkg package selections       |
| `debconf`         | Configure Debian packages            |
| `pip`             | Manage Python packages               |
| `rpm_key`         | Manage RPM GPG keys                  |

### Package Repositories

| Module              | Description                                           |
| ------------------- | ----------------------------------------------------- |
| `deb822_repository` | Manage Debian/Ubuntu repositories using DEB822 format |
| `apt_repository`    | Manage APT repositories *(deprecated)*                |
| `apt_key`           | Manage APT keys *(deprecated)*                        |
| `yum_repository`    | Manage YUM/DNF repositories                           |

For new Debian/Ubuntu automation, `deb822_repository` is the direction to use rather than apt_repository

### Files and Directories

| Module        | Description                                             |
| ------------- | ------------------------------------------------------- |
| `file`        | Manage files, directories, symlinks and file attributes |
| `copy`        | Copy files to managed hosts                             |
| `fetch`       | Copy files from managed hosts                           |
| `get_url`     | Download files using HTTP, HTTPS or FTP                 |
| `template`    | Generate files using Jinja2 templates                   |
| `assemble`    | Assemble files from fragments                           |
| `lineinfile`  | Manage individual lines in text files                   |
| `blockinfile` | Manage blocks of text within files                      |
| `replace`     | Replace text using regular expressions                  |
| `stat`        | Retrieve file/filesystem information                    |
| `find`        | Find files based on criteria                            |
| `tempfile`    | Create temporary files and directories                  |
| `unarchive`   | Extract archives                                        |
| `slurp`       | Read a remote file into Ansible                         |

### Users and Groups

| Module   | Description                             |
| -------- | --------------------------------------- |
| `user`   | Manage user accounts                    |
| `group`  | Manage groups                           |
| `getent` | Query system databases through `getent` |

### Services and System

| Module            | Description                       |
| ----------------- | --------------------------------- |
| `service`         | Generic service management        |
| `systemd_service` | Manage systemd services and units |
| `sysvinit`        | Manage SysV init services         |
| `service_facts`   | Gather service information        |
| `hostname`        | Manage system hostname            |
| `reboot`          | Reboot managed hosts              |

### Commands and Scripts

| Module    | Description                                                |
| --------- | ---------------------------------------------------------- |
| `command` | Execute commands without a shell                           |
| `shell`   | Execute commands through a shell                           |
| `script`  | Transfer and execute a local script                        |
| `raw`     | Execute commands without requiring Python/module subsystem |
| `expect`  | Execute commands and respond to interactive prompts        |

### Scheduling

| Module | Description                         |
| ------ | ----------------------------------- |
| `cron` | Manage crontab and `cron.d` entries |

### Networking and SSH

| Module                | Description                                            |
| --------------------- | ------------------------------------------------------ |
| `iptables`            | Manage iptables rules                                  |
| `known_hosts`         | Manage SSH `known_hosts` entries                       |
| `uri`                 | Interact with HTTP/HTTPS services                      |
| `get_url`             | Download files over HTTP/HTTPS/FTP                     |
| `wait_for`            | Wait for ports, files, connections or other conditions |
| `wait_for_connection` | Wait for a managed host to become reachable            |

### Source Control

| Module       | Description                 |
| ------------ | --------------------------- |
| `git`        | Manage Git checkouts        |
| `subversion` | Manage Subversion checkouts |

### Facts and Information

| Module          | Description                                |
| --------------- | ------------------------------------------ |
| `gather_facts`  | Gather facts using configured fact modules |
| `setup`         | Gather host/system facts                   |
| `package_facts` | Gather installed package information       |
| `service_facts` | Gather service information                 |
| `mount_facts`   | Gather mounted filesystem information      |
| `stat`          | Retrieve file/filesystem information       |

### Inventory and Variables

| Module         | Description                                  |
| -------------- | -------------------------------------------- |
| `add_host`     | Dynamically add hosts to in-memory inventory |
| `group_by`     | Create inventory groups based on facts       |
| `include_vars` | Load variables from files                    |
| `set_fact`     | Define host variables/facts                  |
| `set_stats`    | Define statistics for the current run        |

### Playbook Control

| Module                   | Description                      |
| ------------------------ | -------------------------------- |
| `assert`                 | Assert that expressions are true |
| `debug`                  | Print variables/messages         |
| `fail`                   | Explicitly fail a task           |
| `pause`                  | Pause execution                  |
| `async_status`           | Check asynchronous task status   |
| `meta`                   | Perform Ansible internal actions |
| `import_playbook`        | Import another playbook          |
| `import_role`            | Import a role                    |
| `import_tasks`           | Import task files                |
| `include_role`           | Dynamically include a role       |
| `include_tasks`          | Dynamically include task files   |
| `validate_argument_spec` | Validate role arguments          |

These are the modules currently listed under `ansible.builtin`; unlike collections such as `ansible.posix`, `ansible.windows`, and `community.general`, they are part of `ansible-core`

## Configbox Configuration Items

These are types of items that can be used to support language lessons and supporting tools. 

### Manifest Pipeline

`lessons` and `scriptbox` (`provision/roles/`) are generated the same way as this repo's own `{system_type}_install.sh`/`.ps1` scripts and the `../chef/cookbooks/` cookbooks: the source of truth is always `scriptbox/config/*.yml`, never hand-edited here.

`scriptbox/scripts/generate_ansible_databag.rb <config.yml> <lessons_out.yml> <scriptbox_out.yml>` flattens/resolves a manifest the same way `generate_chef_databag.rb` does for Chef's own data bags, then writes each role's own `vars/<platform>.yml` - e.g. `roles/lessons/vars/ubuntu22.yml`. Chef's `data_bag_item('lessons', node['lessons']['platform'])` explicit lookup-by-key has no automatic-merge Ansible equivalent (`group_vars`/`host_vars` solve a different problem - which vars apply to a host by inventory group, not an arbitrary keyed document); each role's own `tasks/main.yml` instead does the equivalent explicit lookup with `include_vars: "{{ lessons_platform }}.yml"`, where `lessons_platform`/`scriptbox_platform` (`defaults/main.yml`) is the key, overridable per host the same way `group_vars` would set it.

Each role's own `tasks/install_step.yml` then dispatches every step by its `type` to the matching Ansible module - the Ansible analogue of `../chef/cookbooks/{lessons,scriptbox}/libraries/helpers.rb`'s own `lessons_install`/`scriptbox_install` case statement.

## Version Managers

There are no explicit modules that I can find for these tools, so some have written roles that can help.

| Tool    | Role                    | Resource / Task                      |
| ------- | ----------------------- | ------------------------------------ |
| pyenv   | `suzuki-shunsuke.pyenv` | `pyenv`                              |
| rbenv   | `zzet.rbenv`            | Role variables/tasks                 |
| RVM     | `rvm.ruby_rvm`          | `rvm_rubies`                         |
| nvm     | `mgeillon.ansible_nvm`  | `nvm_commands`                       |
| asdf    | `m_pousse.asdf`         | `asdf_plugins`                       |
| uv      | —                       | No established dedicated role/module |
| rustup  | `gantsign.rust`         | `rust_version`                       |
| SDKMAN! | `comses.sdkman`         | `sdkman_install_packages`            |


You can install these through the following:

```bash
ansible-galaxy role install staticdev.pyenv
ansible-galaxy role install zzet.rbenv
ansible-galaxy role install rvm.ruby_rvm
ansible-galaxy role install mgeillon.ansible_nvm
ansible-galaxy role install m_pousse.asdf
ansible-galaxy role install gantsign.rust
ansible-galaxy role install comses.sdkman
```

### Package Managers, System

| Tool           | Ansible Module      | Namespace / Collection  |
| -------------- | ------------------- | ----------------------- |
| Homebrew       | `homebrew`          | `community.general`     |
| Chocolatey     | `win_chocolatey`    | `chocolatey.chocolatey` |
| APT            | `apt`               | `ansible.builtin`       |
| APT Repository | `deb822_repository` | `ansible.builtin`       |
| Cygwin         | —                   | No dedicated module     |
| MSYS2          | `pacman`*           | `community.general`     |
| YUM            | `dnf`*              | `ansible.builtin`       |
| DNF            | `dnf`               | `ansible.builtin`       |
| YUM Repository | `yum_repository`    | `ansible.builtin`       |

### Package Managers, Language

| Tool           | Ansible Module    | Namespace / Collection |
| -------------- | ----------------- | ---------------------- |
| npm            | `npm`             | `community.general`    |
| pip            | `pip`             | `ansible.builtin`      |
| RubyGems / gem | `gem`             | `community.general`    |
| Maven          | `maven_artifact`* | `community.general`    |
| NuGet          | `win_package`*    | `ansible.windows`      |
| CPAN           | `cpanm`           | `community.general`    |
| Cargo          | `cargo`           | `community.general`    |
| PSGallery      | `win_psmodule`    | `community.windows`    |

### Windows Features

| Tool                            | Ansible Module         | Namespace / Collection |
| ------------------------------- | ---------------------- | ---------------------- |
| Windows Server Features / Roles | `win_feature`          | `ansible.windows`      |
| Windows Optional Features       | `win_optional_feature` | `ansible.windows`      |


## Links

* [Index of all Modules](https://docs.ansible.com/projects/ansible/latest/collections/index_module.html?utm_source=chatgpt.com)
* [Ansible.Builtin](https://docs.ansible.com/projects/ansible/14/collections/ansible/builtin/index.html?utm_source=chatgpt.com)
* [Using Ansible modules and plugins](https://docs.ansible.com/projects/ansible/latest/module_plugin_guide/index.html?utm_source=chatgpt.com)
* [Plugins](https://docs.ansible.com/projects/ansible/latest/plugins/plugins.html)