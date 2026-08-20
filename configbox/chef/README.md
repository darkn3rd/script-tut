# Chef

**Chef** is an **Infrastructure as Code** (IaC) configuration management tool used to automate and manage a fleet of servers. Configuration policies are written in **recipes**, which are imperative Ruby scripts executed sequentially in the exact order they are declared. Within these script blocks, Chef leverages Ruby's flexible syntax to provide a domain-specific layout where individual resources ensure the infrastructure converges safely into an idempotent, desired state.

Chef operates on a server-client architecture where an agent, known as the **chef-client**, runs locally on each target node. This agent pulls its assigned configuration policies from a centralized **Chef Server**, compiles the resources, and executes them. Throughout this process, the agent tracks changes and uploads the final status of the convergence back to the **Chef Server**. To manage complex environments, the server organizes configuration data using `environments` (such as staging or production), `roles` (to define server types like web or database), and `data bags` (which store global configuration data and encrypted secrets in JSON format).

Administrators interact with this ecosystem using `knife`, a powerful command-line interface tool. **Knife** allows engineers to bootstrap new instances: installing the agent and registering the machine as a managed node on the Chef Server; and remotely trigger the client execution to kick off an immediate infrastructure convergence.

Individual recipes are bundled together into a cookbook, which serves as the fundamental unit of configuration and policy distribution in the **Chef** ecosystem. To promote reuse and collaboration, the community shares pre-built, open-source cookbooks through a centralized repository known as the **Chef Supermarket**. This allows organizations to leverage community-maintained automation for common infrastructure components instead of building everything from scratch.

## Resources

### Built-In Resources

| Area                    | Chef built-in resources                                                                                                                     |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| **Packages**            | `package`, `apt_package`, `apt_update`, `dnf_package`, `yum_package`, `rpm_package`, `snap_package`, `homebrew_package`, `macports_package` |
| **Repositories**        | `apt_repository`, `yum_repository`                                                                                                          |
| **Language packages**   | `gem_package`, `chef_gem`                                                                                                                   |
| **Windows packages**    | `windows_package`, `msu_package`, `cab_package`, `chocolatey_package`                                                                       |
| **PowerShell packages** | `powershell_package`, `powershell_package_source`                                                                                           |
| **Files**               | `file`, `cookbook_file`, `remote_file`, `remote_directory`, `directory`, `template`, `link`                                                 |
| **Users / groups**      | `user`, `group`                                                                                                                             |
| **Services**            | `service`, `windows_service`, `systemd_unit`, `launchd`                                                                                     |
| **Commands / scripts**  | `execute`, `bash`, `csh`, `powershell_script`, `ruby_block`, `script`                                                                       |
| **Scheduling**          | `cron`, `cron_access`, `cron_d`, `windows_task`, `chef_client_scheduled_task`                                                               |
| **Networking**          | `hostsfile_entry`, `http_request`, `windows_firewall_rule`, `windows_dns_record`, `windows_dns_zone`                                        |
| **Storage / mounts**    | `mount`, `filesystem`, `swap_file`, `windows_pagefile`                                                                                      |
| **Archives**            | `archive`, `seven_zip_archive`                                                                                                              |
| **Certificates**        | `windows_certificate`                                                                                                                       |
| **Windows registry**    | `registry_key`                                                                                                                              |
| **Windows environment** | `windows_env`, `windows_path`                                                                                                               |
| **Windows features**    | `window`                                                                                                                                    |

## Configbox Configuration Items

These are configuration items that can be used to support language lessons and their supporting development tools.

### Version Managers

Version managers are generally provided through community cookbooks from **Chef Supermarket**. Several of these cookbooks expose custom Chef resources for installing the version manager, language runtimes, plugins, and packages.


| Tool    | Cookbook     | Resource                                     |
| ------- | ------------ | -------------------------------------------- |
| pyenv   | `pyenv`      | `pyenv_install`, `pyenv_python`, `pyenv_pip` |
| rbenv   | `ruby_rbenv` | `rbenv_system_install`, `rbenv_ruby`, etc.   |
| RVM     | `rvm`        | RVM custom resources                         |
| nvm     | `nvm`        | `nvm_install`                                |
| asdf    | `asdf`       | [`asdf`](https://supermarket.chef.io/cookbooks/asdf) custom resources   |
| uv      | —            | No established dedicated cookbook identified |
| rustup  | —            | No established current cookbook identified   |
| SDKMAN! | —            | No established current cookbook identified   |

### Package Managers, System

Here Chef is much stronger because most of these map directly to Chef Infra resources.

| Tool           | Chef Resource             | Source                      |
| -------------- | ------------------------- | --------------------------- |
| Homebrew       | `homebrew_package`        | Chef Infra                  |
| Chocolatey     | `chocolatey_package`      | Chef Infra                  |
| APT            | `apt_package` / `package` | Chef Infra                  |
| APT Repository | `apt_repository`          | Chef Infra                  |
| Cygwin         | `cygwin_package`          | [`cygwin`](https://supermarket.chef.io/cookbooks/cygwin) cookbook |
| MSYS2          | `msys2_package`           | [`msys2`](https://supermarket.chef.io/cookbooks/msys2) cookbook |
| YUM            | `yum_package` / `package` | Chef Infra                  |
| DNF            | `dnf_package` / `package` | Chef Infra                  |
| YUM Repository | `yum_repository`          | Chef Infra                  |

Chef's generic `package` resource automatically selects the appropriate package provider for the platform

### Package Managers, Language

This section is where I would be careful not to imply a dedicated Chef resource exists merely because the command can be executed.

| Tool           | Chef Resource / Cookbook | Source                                       |
| -------------- | ------------------------ | -------------------------------------------- |
| npm            | `npm_package`            | Cookbook/custom resource                     |
| pip            | `python_package`         | Cookbook/custom resource                     |
| RubyGems / gem | `gem_package`            | Chef Infra                                   |
| Maven          | —                        | No general built-in Maven package resource   |
| NuGet          | —                        | No dedicated built-in NuGet package resource |
| CPAN           | `cpan_module`            | [`perl`](https://supermarket.chef.io/cookbooks/perl) cookbook (Sous Chefs)                 |
| Cargo          | —                        | No dedicated built-in Cargo resource         |
| PSGallery      | `powershell_package`     | Chef Infra                                   |


### Windows Features

Chef has built-in resources for Windows feature management, so this section can stay very small.

| Tool                     | Chef Resource          | Source     |
| ------------------------ | ---------------------- | ---------- |
| Windows Features / Roles | `windows_feature`      | Chef Infra |
| Windows Feature DISM     | `windows_feature_dism` | Chef Infra |

## Standalone Chef: Solo, Zero, and Knife

Chef Solo and Chef Zero both run Chef cookbooks without a centralized Chef Infra Server. The key difference is how they provide Chef’s server-side features.

* **Chef Solo** executes cookbooks directly from local files.
* **Chef Zero** provides a lightweight local Chef Server API.
* **Knife Solo** and **Knife Zero** add SSH-based workflows for managing remote nodes; they are not execution engines themselves.

### Chef Solo: the legacy execution model

The original Chef Solo engine runs cookbooks directly from files on the target node. It uses configuration such as `solo.rb` to locate cookbooks, roles, and data bags.

Its main limitation is the absence of a Chef Server API and search index:

* Cookbooks must already exist on the target, either in a local directory or downloaded archive.
* Known data bag items can be loaded from local JSON files.
* Server-backed searches such as `search(:node, "role:web")` are unavailable.
* Centralized cookbook distribution, authentication, and infrastructure-wide node discovery are unavailable.

These restrictions can affect cookbooks that expect data from a **Chef Server**. They do not mean that every community cookbook will fail; only those that depend on unavailable server behavior.

Modern versions of the `chef-solo` command use Chef local mode internally. The original behavior is now referred to as legacy mode, so **Chef Solo** should be qualified when discussing current releases.

#### Knife Solo

Knife Solo was a third-party workstation plugin that automated the legacy remote workflow:

1. Connect to a node over SSH.
2. Install Chef if necessary.
3. Copy cookbooks and configuration to the node.
4. Run `chef-solo` remotely.

It reduced deployment friction but did not add a Chef Server API or infrastructure-wide search. The project is deprecated.

### Chef Zero: local mode

Chef Zero is a lightweight Chef Infra Server implementation used by Chef Infra Client’s local mode:

```sh
chef-client --local-mode
# Short form
chef-client -z
```

It runs locally for the duration of the operation and reads Chef objects from a local `chef-repo`. Because Chef Infra Client communicates with a server-compatible API, local mode supports more of the standard Chef workflow than legacy Solo:

* Chef-style search over locally available nodes, roles, environments, and data bags
* Standard repository layouts
* Local node-object persistence
* `knife` commands in local mode
* Easier movement between local development and a centralized Chef Server

Local mode is not identical to running a full production Chef Infra Server. Its search results and infrastructure awareness are limited to objects available in the local repository, and it does not provide centralized authentication, authorization, distribution, or shared state.

#### Knife Zero
Knife Zero extends Chef local mode to remote nodes over SSH. Its primary commands bootstrap new nodes and converge existing ones while using the workstation’s local Chef repository as the source of truth.

Unlike Knife Solo, it can use Chef search to select nodes and can persist selected node attributes as JSON in the repository. This makes it useful for small or transitional environments that need Chef Server-like behavior without operating a centralized server.

Knife Zero’s own documentation notes that it is not strictly a direct replacement for Knife Solo; the two tools use different workflows and data models.

### Comparison 

| Capability | Legacy Chef Solo | Chef Zero / Local Mode | Knife Solo | Knife Zero |
|---|---|---|---|---|
| **Primary role** | Local execution engine | Lightweight local Chef Server | Remote Solo workflow | Remote local-mode workflow |
| **Typical command** | `chef-solo` | `chef-client -z` | `knife solo cook HOST` | `knife zero converge QUERY` |
| **Chef Server-compatible API** | No | Yes, locally | No | Yes, from the workstation |
| **Search support** | No native search | Searches local repository data | No native search | Searches locally managed data |
| **Data bags** | Local JSON and encrypted items; direct lookup but no native search | Repository-backed JSON and encrypted items; direct lookup plus search of indexable data | Copies or stages local data-bag files on the node | Makes repository data bags available through local mode |
| **Roles** | Loaded directly from local role files | Repository-backed objects available through the local Chef API | Copies or stages role files on the node | Makes repository roles available through local mode |
| **Environments** | Loaded directly from local environment files | Repository-backed objects available through the local Chef API | Copies or stages environment files on the node | Makes repository environments available through local mode |
### Practical guidance

For new standalone Chef workflows, use `chef-client -z` rather than designing around legacy **Chef Solo**. 

Use Knife Zero when you need an SSH-based, repository-backed workflow for managing remote nodes without a centralized Chef Infra Server.

For an existing Knife Solo installation, treat migration as a workflow change rather than a simple command-for-command replacement.

# Further Reading and References

* Progress Chef Documenation
  * [chef-solo](https://docs.chef.io/client/18/features/chef_solo/)
    * [solo.rb](https://docs.chef.io/client/19/features/chef_solo/config_rb_solo/)
  * [Chef Infra Client (executable)](https://docs.chef.io/client/18/reference/ctl_chef_client/)
  * [About Data Bags](https://docs.chef.io/client/19/policy/data_bags/)
  * [About Policy](https://docs.chef.io/client/19/policy/)
  * [About Environments](https://docs.chef.io/client/19/policy/environments/)
  * [About Roles](https://docs.chef.io/client/19/policy/roles/)
* [Knife Zero](https://knife-zero.github.io/)


Bugs/Issues Encountered

* Vagrant
  * https://github.com/hashicorp/vagrant/issues/12587
* Virtualbox
  * https://github.com/VirtualBox/virtualbox/issues/799
* Chef
  * https://github.com/chef/chef/issues/16309
  * https://github.com/chef/chef/issues/16281