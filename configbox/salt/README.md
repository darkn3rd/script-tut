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

## Configbox Configuration Items

The `lessons` area (gen_scripts/shell_scripts/compiled_lang/win_scripts) is
implemented once in `shared_states/lessons` and consumed two different ways,
each living under its own top-level directory here:

| Directory  | How it's run                                              | Where its data comes from                                                                   |
| ---------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------------- |
| `static/`  | `salt-call --local` - a minion applying against its own local file/pillar roots, no master involved | `roots/pillar/lessons/<platform>.sls` - an ordinary pillar file, looked up by `grains.get`/`pillar.get` the normal way |
| `roster/`  | `salt-ssh` - no persistent agent on the target at all; a small self-contained package is pushed over plain SSH and run once | `roster.yaml`'s own `minion_opts.grains` - every value embedded directly in one generated file, nothing looked up externally |

Both are fed by `scriptbox/scripts/generate_salt.rb`, which reads the same
`scriptbox/config/*.yml` source every other tool in this repo's `configbox/`
tree reads:

```
scriptbox/scripts/generate_salt.rb <config.yml> <out_path> --tree static|roster [--select TAG,TAG] [--exclude TAG,TAG]
```

`shared_states/lessons/map.jinja` is what makes one state tree work under
either delivery mechanism: it looks up a `lessons` **grain** first, and only
falls back to a `lessons` **pillar** value if no grain was set. `static/`
never sets the grain at all (so it falls through to pillar); `roster/` sets
nothing *but* the grain (there's no meaningful pillar data in that tree at
all - see `roster/roots/pillar/top.sls`'s own comment). Neither tree needs to
know the other exists.

### Applying via `static/`

```sh
cd configbox/salt/static/systems/ubuntu22
ruby ../../../../../scriptbox/scripts/generate_salt.rb \
  ../../../../../scriptbox/config/ubuntu2204.yml \
  ../../roots/pillar/lessons/ubuntu22.sls \
  --tree static
vagrant up
```

### Applying via `roster/`

`salt-ssh` needs a real Python + SSH-client environment to run *from* - see
its own man page for what "the machine you invoke it on" actually needs.
Rather than requiring that of whatever machine runs `vagrant up`, this tree
has the guest target itself: `vagrant up` installs `salt-ssh` and a small
self-generated SSH keypair inside the guest, then runs `salt-ssh` against
`127.0.0.1` from inside that same guest, over that keypair. Nothing outside
the VM needs `salt-ssh` installed at all.

```sh
cd configbox/salt/roster/systems/ubuntu22
ruby ../../../../../scriptbox/scripts/generate_salt.rb \
  ../../../../../scriptbox/config/ubuntu2204.yml \
  ../../roster.yaml \
  --tree roster
vagrant up
```

Re-run the `generate_salt.rb` step (from either tree) and `vagrant provision`
any time `scriptbox/config/*.yml` changes - neither tree regenerates its own
data automatically.

## Vendoring Formulas

A **formula** is a ready-made state tree someone else wrote and published as
its own Git repository - the `golang` formula vendored under
`.formula-vendor/golang/` (fetched from
[saltstack-formulas/golang-formula](https://github.com/saltstack-formulas/golang-formula))
is one example already in this repo. Using one just means adding its own
top-level directory to `file_roots` (already done for both `static/` and
`roster/` - see their own `minion`/`master` files) and pulling it in with a
plain `include:` line, the same as any of this tree's own state files
`include:` each other.

`.formula-vendor/` itself is gitignored (only fetched formulas' names/
versions are ever tracked, never their downloaded content) - fetch one on
demand:

```sh
cd configbox/salt/.formula-vendor
git clone --depth 1 https://github.com/saltstack-formulas/golang-formula /tmp/golang-formula-clone
cp -r /tmp/golang-formula-clone/golang ./golang
rm -rf /tmp/golang-formula-clone
```

(Only the formula's own top-level state directory - here, `golang/` - needs
to be copied in; the rest of that repository, e.g. its own test suite, isn't
needed at run time.)

A formula's own pillar/grain expectations are whatever its own
`pillar.example` documents - nothing about how it's vendored here is
formula-specific beyond that directory copy. `scriptbox/config/ubuntu2204.yml`'s
own `salt_formula: golang` step (an opt-in alternative to the plain apt+PPA
`go` step, selected via `--select salt_formula_golang`) shows the pattern:
a `formula_pillar:` key on the step carries whatever that one formula
expects, hoisted to the top level of the generated pillar/grain data by
`generate_salt.rb` (a formula has no idea this tree's own `lessons:` key
exists, so its data can't live nested under it).