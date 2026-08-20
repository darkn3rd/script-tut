# CFEngine

## Promise Types Supported

| CFEngine promise type | Rough Chef/Puppet equivalent            | What it manages                                                                      |
| --------------------- | --------------------------------------- | ------------------------------------------------------------------------------------ |
| `files`               | `file`, `directory`, `template`, `link` | Files, directories, links, permissions, ownership, ACLs, copying, editing, templates |
| `packages`            | `package`                               | Software packages                                                                    |
| `services`            | `service`                               | System services                                                                      |
| `users`               | `user`                                  | Local users and memberships                                                          |
| `processes`           | process resources / exec                | Running processes, counts, signals, stopping/restarting                              |
| `commands`            | `execute`                               | Execute external commands/scripts                                                    |
| `storage`             | `mount`                                 | Mounts, filesystems, disk/free-space checks                                          |
| `databases`           | DB/registry-specific resources          | SQL, LDAP and Windows Registry in supported configurations                           |
| `methods`             | class/include/custom resource           | Invoke another CFEngine bundle                                                       |
| `guest_environments`  | virtualization                          | Virtual-machine/guest environments                                                   |
| `classes`             | facts/conditions                        | Define conditional state                                                             |
| `vars`                | variables                               | Define variables/data                                                                |
| `defaults`            | defaults                                | Default parameter values                                                             |
| `reports`             | `notify`                                | Generate output/reports                                                              |
| `meta`                | metadata                                | Bundle metadata                                                                      |

### Package Modules

| Package module  | Package system        |
| --------------- | --------------------- |
| `apt_get`       | Debian/Ubuntu APT     |
| `yum`           | YUM                   |
| `dnf`           | DNF                   |
| `dnf_group`     | DNF package groups    |
| `pkg`           | Various `pkg` systems |
| `pkgsrc`        | NetBSD/pkgsrc         |
| `freebsd_ports` | FreeBSD Ports         |
| `slackpkg`      | Slackware             |
| `snap`          | Snap                  |
| `msiexec`       | Windows MSI           |
| `nimclient`     | AIX NIM               |


## Links

* [cfengine-yum](https://github.com/nickanderson/cfengine-yum)
* [cfengine-apt](https://github.com/nickanderson/cfengine-apt)
* [copbl](https://github.com/nickanderson/copbl) aka [The CFEngine Standard Library](https://cfengine.com/starterkit)
* [SURFsara CFEngine Library (SCL)](https://github.com/basvandervlies/cf_surfsara_lib)

* Docs
  * [Promise Types](https://docs.cfengine.com/docs/lts/reference/promise-types/)
  * [Modules](https://docs.cfengine.com/docs/3.27/reference/language-concepts/modules/)
  * [Users](https://docs.cfengine.com/docs/master/reference/promise-types/users/)
  * [Files](https://docs.cfengine.com/docs/lts/reference/promise-types/files/)
