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


## Configbox Configuration Items

The `lessons` area (gen_scripts/shell_scripts/compiled_lang/win_scripts) is
implemented once in `shared_policy/lessons` and consumed two different ways,
each living under its own top-level directory here - the difference between
them is entirely about *how the data reaches the agent*, never the tree
itself:

| Directory     | How it's run                                                                                     | Where its data comes from                                                                                        |
| ------------- | -------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `standalone/` | `cf-agent -Kf promises.cf` applied directly - no policy hub involved at all                        | `def.json` sitting right next to `promises.cf` - a CFEngine **augments** file, auto-merged into the data variable `def.lessons` at parse time |
| `hub/`        | the guest bootstraps to itself (`cf-agent --bootstrap 127.0.0.1`) and runs as its own policy hub, serving policy to itself over `cf-serverd` | its own `def.json`, assembled (along with `promises.cf` and this tree's shared bundles) into `/var/cfengine/masterfiles/` before bootstrapping - and synced into `/var/cfengine/inputs/` (`cf-agent`'s own actual working copy) on *every* provision, not just the first, since nothing else does that without the full standard masterfiles library's own `update.cf` bundle, which this tree doesn't pull in |

Both trees are fed by `scriptbox/scripts/generate_cfengine.rb`, which reads
the same `scriptbox/config/*.yml` source every other tool in this repo's
`configbox/` tree reads:

```
scriptbox/scripts/generate_cfengine.rb <config.yml> [out_path] --tree standalone|hub [--select TAG,TAG] [--exclude TAG,TAG]
```

`out_path` is optional - omit it and the generator looks its own default up in
`cmpaths.toml` at the repo root instead (see that file's own header comment).

### Applying via `standalone/`

```sh
cd configbox/cfengine/standalone/systems/ubuntu22
ruby ../../../../../scriptbox/scripts/generate_cfengine.rb \
  ../../../../../scriptbox/config/ubuntu2204.yml \
  --tree standalone
vagrant up
```

### Applying via `hub/`

No second machine is involved - a CFEngine policy hub is just an ordinary
host running `cf-serverd`, so the guest bootstraps to itself
(`cf-agent --bootstrap 127.0.0.1`) rather than a real remote hub being
required.

```sh
cd configbox/cfengine/hub/systems/ubuntu22
ruby ../../../../../scriptbox/scripts/generate_cfengine.rb \
  ../../../../../scriptbox/config/ubuntu2204.yml \
  --tree hub
vagrant up
```

Re-run the `generate_cfengine.rb` step (from either tree) and
`vagrant provision` any time `scriptbox/config/*.yml` changes - neither tree
regenerates its own data automatically.

## Vendoring Modules

A **module** here is a ready-made bundle library someone else wrote and
published as its own Git repository - the `apt` module vendored under
`.module-vendor/apt/` (fetched from
[nickanderson/cfengine-apt](https://github.com/nickanderson/cfengine-apt))
is one example already in this repo. It provides a namespaced
`apt:package_version_priority_pinned(name, version, priority, state)`
bundle for pinning an apt package to an exact version/priority - used by
this tree's own `apt_pin` step type (see
`shared_policy/lessons/install_step.cf`), additive to the plain apt install
every other tool's own `go` step already does, not a replacement for it.

That vendored file calls `default:mog(...)`/`default:tidy` exactly as
its own upstream repository wrote it - two small bodies that normally come
from CFEngine's own standard masterfiles library. Neither tree here pulls
that library in, so `shared_policy/default_shim.cf` supplies minimal
stand-ins under that same `default`
namespace instead of vendoring the whole library for two bodies.

`.module-vendor/` itself is gitignored (only a fetched module's name is
ever tracked here, never its downloaded content) - fetch one on demand:

```sh
cd configbox/cfengine/.module-vendor
git clone --depth 1 https://github.com/nickanderson/cfengine-apt /tmp/cfengine-apt-clone
mkdir -p apt
cp /tmp/cfengine-apt-clone/policy/*.cf ./apt/
rm -rf /tmp/cfengine-apt-clone
```

(Only the module's own `policy/` directory needs to be copied in; the rest
of that repository, e.g. its own test/media files, isn't needed at run
time.) A module fetched this way is added to `inputs =>` (`standalone/
promises.cf`) or copied alongside the rest of this tree's own policy
(`hub/`'s own bootstrap script) - nothing about how it's vendored here is
module-specific beyond that.

The much larger [SURFsara CFEngine Library (SCL)](https://github.com/basvandervlies/cf_surfsara_lib)
listed below is a full framework covering dozens of unrelated services, not
a single-purpose module in the same sense - worth knowing about, not
vendored here.

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
