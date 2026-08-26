# CFEngine implementation (standalone + hub) with a vendored module

## Context

This repo already has parallel implementations of the same tutorial "lessons"
provisioning area in Chef, Ansible, Puppet, and Salt, each living under its
own `configbox/<tool>/` directory and driven off the same shared source of
truth (`scriptbox/config/ubuntu2204.yml`) via a per-tool Ruby generator in
`scriptbox/scripts/`. CFEngine is next.

The user already created a skeleton: `configbox/cfengine/README.md` (a
promise-type/package-module reference table plus a Links section already
pointing at `nickanderson/cfengine-apt`, `nickanderson/cfengine-yum`, and
`basvandervlies/cf_surfsara_lib` - the "SCL"/`lib/scl/stdlib.cf` library
mentioned), an empty `configbox/cfengine/systems/README.md`, and an empty
`configbox/cfengine/systems/ubuntu22/Vagrantfile` - a flat, single-tree
skeleton (unlike Salt/Puppet's already-split multi-tree ones).

Two decisions were checked directly with the user this session rather than
assumed:
- Whether to keep this flat/single-tree or split into multiple delivery
  mechanisms like Puppet (site/hiera/enc) and Salt (masterless/roster/
  dynamic). Initially answered "single tree" - but after clarifying that a
  CFEngine "policy hub" is just an ordinary host running `cf-serverd`, not a
  dedicated server (the guest can bootstrap to itself, `cf-agent --bootstrap
  127.0.0.1`, the same self-targeting trick already used for Salt's roster/
  dynamic trees and Ansible's `ansible_local`), the user chose to add the
  hub tree back in after all. **Final: two trees, `standalone/` and
  `hub/`.**
- Which external module to vendor: `nickanderson/cfengine-apt` (small,
  focused, namespaced `apt:` bundle for apt package pinning), not the full
  `cf_surfsara_lib` SCL library (confirmed to be a large, full framework
  covering dozens of unrelated services - not comparable in scope to the
  single-purpose vendored units the other tools used, puppetlabs-stdlib/
  golang-formula). SCL stays a Links-only reference, already in the README.

Hard requirement carried over from every previous tool's build: no comments/
docs in the CFEngine tree may reference Puppet, Chef, Ansible, Salt, or any
other CM tool by name - everything must read standalone, in CFEngine's own
vocabulary (bundles, promises, augments, classes).

## Approach

### 1. Shared bundle library - `configbox/cfengine/shared_policy/lessons/`

Mirrors `shared_modules/lessons` (Puppet) / `shared_states/lessons` (Salt) -
one hand-written bundle tree, delivery-agnostic, fed entirely by CFEngine's
own native data-delivery mechanism: **augments** - a `def.json` sitting next
to `promises.cf`, auto-merged by `cf-agent` into a `data` variable
`def.<key>` in the `default` namespace, no extra bundle logic needed to read
it (the direct CFEngine analogue of Puppet's hiera auto-lookup / Salt's
pillar).

- `lessons.cf` - `bundle agent lessons`, unparameterized (reads
  `def.lessons` directly, same classifier/delivery-agnostic spirit as
  Puppet's init.pp / Salt's map.jinja). Handles the apt-get-update-once step
  and the ungated `common_steps` list, then `methods:`-includes each area
  bundle guarded by its own `def.lessons[gates][<area>]` boolean.
- `install_step.cf` - `bundle agent lessons_install_step(step, user, home)`,
  the direct analogue of `install_step.pp`'s `case $type` / Salt's Jinja
  macro. CFEngine has no switch-on-a-string either; the idiom is `classes:
  "is_<type>" expression => strcmp("$(step[type])", "<type>");` then one
  `packages:`/`files:`/`commands:`/`methods:` block per type guarded by
  that class. MVP scope only (same six as the Salt pass, minus asdf/pyenv/
  rbenv/etc.): `apt` (plain + `apt_repository` PPA + `add_apt_repo` raw
  key/list variants), `apt_pin` (new - dispatches to the vendored `apt:`
  bundle), `sysctl`, `file`, `append`, `script`. Every other step type is
  explicitly out of scope, documented in the file's own header as "add a
  new `classes:`/promise block here following this same pattern."
- Area bundles (`gen_scripts.cf`, `shell_scripts.cf`, `compiled_lang.cf`,
  `win_scripts.cf`) - hand-written, each iterating its own slice of
  `def.lessons[areas][<area>]` and invoking `lessons_install_step` once per
  entry. Per-step iteration uses the confirmed-real CFEngine idiom (found
  live in SCL's own `packages.cf`): `"i" slist => getindices("steps");`
  then `"step" data => mergedata("{}", "steps[$(i)]");` to pull one nested
  hash out of the generated array, then `usebundle =>
  lessons_install_step(step, "$(user)", "$(home)")` (bare container
  reference, no `$()`) - CFEngine expands the whole chain once per `$(i)`.

Both trees below `inputs =>` this same tree - it never knows or cares which
one is running it, same as `shared_states`'s own relationship to Salt's
three trees.

### 2. `standalone/` tree - masterless

- `configbox/cfengine/standalone/promises.cf` (hand-written entry point) -
  `body common control { bundlesequence => { "lessons" }; inputs => {
  "../shared_policy/lessons/lessons.cf", "../shared_policy/lessons/
  install_step.cf", ..., "../.module-vendor/apt/apt-pin-packages.cf",
  "../.module-vendor/apt/pin-package.cf" }; }`.
- `configbox/cfengine/standalone/def.json` (**generated**) - the augments
  file: `{"vars": {"def": {"lessons": {"value": {user, common_steps,
  gates, areas}}}}}`.
- `configbox/cfengine/standalone/systems/ubuntu22/Vagrantfile` - relocated
  from the existing flat skeleton (moves the current empty `configbox/
  cfengine/systems/ubuntu22/Vagrantfile` here rather than leaving a stray
  empty one behind). Syncs the repo root to `/var/script-tut` (existing
  repo-wide convention), runs the shared bootstrap script, then a plain
  `config.vm.provision "shell"` step running `cf-agent --no-lock -Kf
  /var/script-tut/configbox/cfengine/standalone/promises.cf` - masterless,
  no hub involved. (No Vagrant-native CFEngine provisioner exists, unlike
  Puppet/Salt's built-in ones, so this is a shell step, same as Salt's
  roster/dynamic trees needed.)
- `configbox/cfengine/standalone/systems/README.md` - relocated the same
  way from the existing flat skeleton.

### 3. `hub/` tree - self-bootstrapped policy hub

- `configbox/cfengine/hub/promises.cf` + `configbox/cfengine/hub/def.json`
  (**generated**) - same shape as standalone's, just a second copy at a
  second path (the difference between the two trees is entirely about *how
  the data reaches the agent*, never the tree itself - same framing Salt's
  own README already uses for masterless vs. roster).
- `configbox/cfengine/scripts/ubuntu22_cfengine_hub_bootstrap.sh` -
  idempotent: copies `hub/promises.cf`, `hub/def.json`, `../shared_policy/
  lessons/`, and `../.module-vendor/apt/` into `/var/cfengine/masterfiles/`
  (the standard location a CFEngine policy hub serves policy from), then
  runs `cf-agent --bootstrap 127.0.0.1` - bootstrapping the guest to
  itself. On a fresh box this starts `cf-serverd`/`cf-execd` and performs
  the initial policy pull into `/var/cfengine/inputs` + first run
  automatically; the Vagrantfile follows up with a plain `cf-agent -K` to
  force one deterministic convergence run rather than waiting on
  `cf-execd`'s own splayed schedule, so `vagrant provision` reliably
  finishes converged.
- `configbox/cfengine/hub/systems/ubuntu22/Vagrantfile` - syncs the repo,
  runs the shared bootstrap script (installs `cfengine-community`) then the
  hub-bootstrap script above.

### 4. Generator - `scriptbox/scripts/generate_cfengine.rb`

Mirrors `generate_puppet.rb`/`generate_salt.rb`'s structure, reusing the
same shared helpers from `resolve_order.rb`/`generate_chef_databag.rb`
(`root_key`, `step_to_entry`, `consolidate_apt`, `LESSON_AREAS`,
`COMMON_AREA`, `flatten`, `resolve_included`, `topological_order`,
`check_version_needs!`, `deep_stringify_keys`).

- `TREES = %w[standalone hub].freeze`, CLI: `<config.yml> [out_path]
  --tree standalone|hub [--select TAG,TAG] [--exclude TAG,TAG]`.
- `lessons_shape(lessons_data)` - same `user`/`common_steps`/`gates`/
  `areas` dict Puppet/Salt already build.
- One shared `write_augments(name, lessons_data, out_path)` used by both
  trees (no shape difference needed - see point 3 above) - wraps that
  shape as `{"vars" => {"def" => {"lessons" => {"value" => ...}}}}`,
  deep-stringified, `File.write(out_path, ..., mode: 'wb')` (same CRLF-
  corruption guard every other generator needed on this Windows dev box).
- `out_path ||= cmpath('cfengine', options[:tree], name)`.
- `resolve_order.rb`: add `'apt_pin'` to `PACKAGE_TYPES` (one-line,
  additive, same treatment `salt_formula` got).
- `generate_chef_databag.rb`'s `step_to_entry`: add
  `entry[:pin] = step[:pin] if step[:pin]` - a harmless additive pass-
  through (mirrors the existing `formula_pillar` passthrough), only ever
  populated for an `apt_pin`-typed step none of the other generators select
  by default.
- `cmpaths.toml`: new section -
  ```toml
  [cfengine]
  standalone = "configbox/cfengine/standalone/def.json"
  hub        = "configbox/cfengine/hub/def.json"
  ```
- `Rakefile`: new `generate:cfengine` task (both trees), added to
  `generate:all`.

### 5. New config data - `scriptbox/config/ubuntu2204.yml`

Additive sibling entry under the existing `go:` packages list (does not
touch the existing `apt_repository: ppa:longsleep/golang-backports` entry -
demonstrates a genuinely new capability, pinning, rather than an
alternative install path):
```yaml
- apt_pin: golang-go
  pin:
    version: '<confirm currently-installed apt version at build/test time>'
    priority: '1001'
  tags: [cfengine_apt_pin]
```
Opt-in only, via `--select cfengine_apt_pin` - every other generator's
default output is unaffected since none of them ever ask for that tag
(same opt-in convention `salt_formula_golang` already established).

### 6. Vendoring `cfengine-apt`

- `.gitignore`: new block mirroring `.forge-vendor`/`.formula-vendor`
  exactly - `configbox/cfengine/.module-vendor/*` + `!configbox/cfengine/
  .module-vendor/.gitkeep` (`.module-vendor` - CFEngine's own ecosystem
  calls these "modules"/"CFEngine Build" units, per both fetched repos'
  own `cfbs.json`).
- Vendor target: `configbox/cfengine/.module-vendor/apt/` - the two `.cf`
  files under `nickanderson/cfengine-apt`'s own `policy/` directory
  (`apt-pin-packages.cf`, `pin-package.cf`) - already namespaced `apt:` by
  their own `body file control { namespace => "apt"; }` declaration, so no
  renaming needed. Added to both trees' `promises.cf` `inputs =>` list
  (standalone directly; hub via the hub-bootstrap script's copy into
  `/var/cfengine/masterfiles/`).
- `configbox/cfengine/README.md`: append a "Configbox Configuration Items"
  section (the standalone/hub table + augments/`def.json` shape, in
  CFEngine's own vocabulary, mirroring Salt's own such section) and a
  "Vendoring Modules" section (manual `git clone`/tarball fetch into
  `.module-vendor`, mirroring the Forge/formula sections' spirit in the
  other tools' READMEs).

## Verification

1. `ruby scriptbox/scripts/generate_cfengine.rb scriptbox/config/
   ubuntu2204.yml --tree standalone` (then `--tree hub`) and confirm both
   `def.json` outputs have no `\r` bytes (same check used for every other
   generator).
2. `vagrant up` in `configbox/cfengine/standalone/systems/ubuntu22/`, then
   `vagrant provision` - expect a clean `cf-agent -Kf promises.cf` exit 0
   on a fresh box, and idempotent (no repairs reported) on a second run.
3. `vagrant up` in `configbox/cfengine/hub/systems/ubuntu22/systems/
   ubuntu22/` - confirm the bootstrap-to-self step succeeds (`cf-agent
   --bootstrap 127.0.0.1`), `cf-serverd` comes up, and the follow-up
   `cf-agent -K` converges cleanly.
4. Re-run either tree's generator with `--select cfengine_apt_pin` and
   confirm `apt-cache policy golang-go` (or `/etc/apt/preferences.d/`)
   shows the pin actually took effect via the vendored `apt:package_
   version_priority_pinned` bundle.
5. Expect real iteration here, same as every previous tool's build: the
   exact CFEngine apt-repo bootstrap steps, the precise `mergedata`/
   iteration syntax in the area bundles, the hub bootstrap/trust handshake
   details, and `apt_get` package_module parameter names are informed
   designs pending a live `cf-agent` run, not verified syntax - treat the
   first `vagrant provision` on each tree as the real test, not a
   formality.