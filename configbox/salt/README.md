# Salt Project

## Salt States

| Capability            | Salt state       | Rough Puppet/Chef equivalent                   |
| --------------------- | ---------------- | ---------------------------------------------- |
| Packages              | `pkg`            | Puppet `package` / Chef `package`              |
| Package repositories  | `pkgrepo`        | `yumrepo` / `apt_repository`, `yum_repository` |
| Files                 | `file`           | `file`                                         |
| Directories           | `file.directory` | Puppet `file` / Chef `directory`               |
| Symlinks              | `file.symlink`   | Puppet `file` / Chef `link`                    |
| Templates             | `file.managed`   | Puppet `file` / Chef `template`                |
| Services              | `service`        | `service`                                      |
| Users                 | `user`           | `user`                                         |
| Groups                | `group`          | `group`                                        |
| Commands              | `cmd`            | Puppet `exec` / Chef `execute`                 |
| Cron                  | `cron`           | `cron`                                         |
| `at` jobs             | `at`             | scheduled command                              |
| Mounts                | `mount`          | `mount`                                        |
| Host entries          | `host`           | Puppet `host` / Chef `hostsfile_entry`         |
| Environment variables | `environ`        | environment resource                           |
| Kernel modules        | `kmod`           | kernel module                                  |
| sysctl                | `sysctl`         | `sysctl`                                       |
| SELinux               | `selinux`        | SELinux resources                              |
| ACLs                  | `linux_acl`      | ACL management                                 |
| FirewallD             | `firewalld`      | firewall resource                              |
| iptables              | `iptables`       | firewall resource                              |
| nftables              | `nftables`       | firewall resource                              |
| IP sets               | `ipset`          | firewall resource                              |
| Network interfaces    | `network`        | network resources                              |
| LVM                   | `lvm`            | storage resources                              |
| RAID                  | `mdadm_raid`     | storage resources                              |
| Block devices         | `blockdev`       | storage resources                              |
| Archives              | `archive`        | Chef `archive`                                 |
| Git repositories      | `git`            | Chef `git`                                     |
| GPG                   | `gpg`            | GPG/key resources                              |
| NTP                   | `ntp`            | NTP resource                                   |
| logrotate             | `logrotate`      | logrotate resource                             |
| Alternatives          | `alternatives`   | alternatives resource                          |
| INI files             | `ini_manage`     | structured file editing                        |
| Augeas                | `augeas`*        | Puppet `augeas`                                |

## Package / Language Management

| Package / version manager | Built-in Salt support | State                                           |
| ------------------------- | --------------------: | ----------------------------------------------- |
| APT                       |                     ✅ | `pkg`                                           |
| YUM                       |                     ✅ | `pkg`                                           |
| DNF                       |                     ✅ | `pkg`                                           |
| Pacman                    |                     ✅ | `pkg`                                           |
| Zypper                    |                     ✅ | `pkg`                                           |
| Homebrew                  |                     ✅ | `pkg`                                           |
| Nix                       |                     ✅ | `pkg`                                           |
| FreeBSD pkg               |                     ✅ | `pkg`                                           |
| APT/YUM/DNF repositories  |                     ✅ | `pkgrepo`                                       |
| Chocolatey                |                     ✅ | `chocolatey`                                    |
| pip                       |                     ✅ | `pip_state`                                     |
| Ruby Gems                 |        historically ✅ | `gem`                                           |
| Cygwin packages           |        historically ✅ | `cyg`                                           |
| rbenv                     |        historically ✅ | `rbenv`                                         |
| RVM                       |        historically ✅ | `rvm`                                           |





* [Salt Modules](https://docs.saltproject.io/en/3008/ref/states/all/index.html)