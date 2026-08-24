# Scripts Notes

These are some notes on using these scripts.

## Unit Tests

`test/` formalizes the scenarios documented below as Minitest cases -
`test_resolve_order.rb` covers the pipeline mechanism itself
(flatten/topological_order/resolve_included/unit_span/natural_prefix)
against small synthetic fixtures, `test_generate_install_script.rb` covers
path_matches?/expand_selectors plus the actual A-E scenarios below run
against the real `../config/ubuntu2204.yml`. Pure functions over plain
data - no VM, no file writes - so this runs in milliseconds and is safe
to run on every change, unlike the Vagrant-based testing further down.

```bash
rake test
```

## Integration Tests

`test/integration/integration_test.rb` proves a generated install
script actually works on a real box, not just that its own step list is
structurally correct (that's what the unit tests above already cover) -
the class of bug this exists for is exactly the CPAN `FirstTime.pm`
reentrancy failure this session found, which no amount of step-list
inspection alone would have caught. One scenario (A-E, same table as
below) per run:

1. generate that scenario's own install script, named
   `scriptbox/generated/<letter>.<slug>.sh` (e.g. `a.baseline.sh`) -
   each scenario gets its own file, not one shared file every run
   overwrites.
2. `vagrant up --no-provision` / `vagrant provision` against
   `configbox/bubblegum/hosts/virtualbox/ubuntu22`, with `TEST_PATH` set
   to that scenario's own script - its Vagrantfile provisions with
   whatever `TEST_PATH` points at, falling back to its own default
   `ubuntu22_install.sh` when unset, so a plain `vagrant provision` run
   by hand still works exactly as before.
3. `vagrant ssh` in and run `verify_commands.rb --format json`,
   redirected straight into `/var/script-tut` - the Vagrantfile's own
   synced folder mapping this whole repo into the guest - so the guest
   writes its own report directly into `test/integration/actual/`
   rather than it being captured over SSH's own stdout. Run through an
   *interactive* shell (`bash -ic`, not `-c`/`-lc`) on purpose: Ubuntu's
   own `.bashrc` refuses to run at all unless the shell is interactive,
   and that's where the per-user PATH tools (`cpanm` via local::lib,
   `groovy` via sdkman) actually get added to `PATH` - confirmed
   directly, twice, that anything less misreports genuinely-installed
   tools as `MISSING`.
4. flatten that into `{"language" / "language > tool" => OK/MISSING/N/A}`
   and compare against this scenario's own committed
   `test/integration/expected/<letter>.<slug>.json` baseline - the
   flattened *actual* result is also always written to
   `test/integration/actual/` (gitignored, alongside the guest's own
   raw `--format json` output), so there's a real artifact to inspect
   after a FAIL without re-running anything.
5. report PASS/FAIL per item (`--format text`, the default, or
   `json`/`yaml`; `--junit PATH` writes a JUnit XML report too), and
   exit 1 if anything failed, 0 otherwise.
6. `vagrant destroy -f`, so the next run starts from a clean VM.

```bash
cd test/integration

# Run scenario A against its committed expected baseline.
ruby integration_test.rb A

# Establish (or intentionally update) what "correct" means for a
# scenario - captures the real, just-fetched result as the new
# expected baseline instead of comparing against one. Never hand-author
# an expected/*.json from theory; only from a real run like this.
ruby integration_test.rb A --record

# Leave the VM up afterward (skip vagrant destroy) to poke around.
ruby integration_test.rb A --no-destroy

# Also write a JUnit report, e.g. for CI to pick up.
ruby integration_test.rb A --junit /tmp/scenario-a.xml
```

Unlike the unit tests above, this is slow (a real multi-minute VM
boot+provision+destroy cycle per scenario) and not something to run on
every change - a deliberately-triggered suite, one letter at a time.

## generate_install_script.rb

This script generates an install script: GNU Bash (`.sh`) for POSIX environments and powershell (`.ps1`) for Windows.  The scripts will vary depending on the options selected. 

### Ubuntu 22.04

These are some combinations you would try below:

* **A. Baseline (no flags)** — system ruby/python only, `groovy` via sdkman default:
  ```bash
  ./generate_install_script.rb ../config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}"
  ```
* **B. Traditional bundle** — `rbenv` + `pyenv` (covers python2 too, same tag) + `sdkman groovy`, explicit:
  ```bash
  ./generate_install_script.rb ../config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select rbenv,pyenv,sdkman_groovy
  ```
* **C. Full asdf** — verified this pulls in the asdf bootstrap + all three plugins/installs:
  ```bash
  ./generate_install_script.rb ../config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy
  ```
* **D. Mixed per-language **— `rbenv` for ruby, `asdf` for python, `sdkman` for groovy:
  ```bash
  ./generate_install_script.rb ../config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select rbenv,asdf_python,sdkman_groovy
  ```
* E. **Exclude/omission sanity check** — `asdf` minus groovy, so groovy has no active path at all (confirms --exclude vetoes and the omission comment fires cleanly instead of emitting a broken command):
  ```bash
  ./generate_install_script.rb ../config/ubuntu2204.yml \
    "lessons.gen_scripts.{ruby,python2,python3,groovy}" \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy \
    --exclude asdf_groovy
  ```

When you are read to test one of these combinations:

```bash
REPO=$(realpath ../..)
pushd $REPO/configbox/bubblegum/hosts/virtualbox/ubuntu22
vagrant up --no-provision # launch vm
vagrant provision         # test script
popd
```

## generate_chef_databag.rb

### Ubuntu 22.04

These are some combinations you would try below:

* **A. Baseline (no flags)** — system ruby/python only, `groovy` via sdkman default:
  ```bash
  ./generate_chef_databag.rb ../config/ubuntu2204.yml \
    ../../configbox/chef/data_bags/lessons/ubuntu22.json
  ```
* **B. Traditional bundle** — `rbenv` + `pyenv` (covers python2 too, same tag) + `sdkman groovy`, explicit:
  ```bash
  ./generate_chef_databag.rb ../config/ubuntu2204.yml \
    ../../configbox/chef/data_bags/lessons/ubuntu22.json \
    --select rbenv,pyenv,sdkman_groovy
  ```
* **C. Full asdf** — verified this pulls in the asdf bootstrap + all three plugins/installs:
  ```bash
  ./generate_chef_databag.rb ../config/ubuntu2204.yml \
    ../../configbox/chef/data_bags/lessons/ubuntu22.json \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy
  ```
* **D. Mixed per-language **— `rbenv` for ruby, `asdf` for python, `sdkman` for groovy:
  ```bash
  ./generate_chef_databag.rb ../config/ubuntu2204.yml \
    ../../configbox/chef/data_bags/lessons/ubuntu22.json \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy
  ```
* E. **Exclude/omission sanity check** — `asdf` minus groovy, so groovy has no active path at all (confirms --exclude vetoes and the omission comment fires cleanly instead of emitting a broken command):
  ```bash
  ./generate_chef_databag.rb ../config/ubuntu2204.yml \
    ../../configbox/chef/data_bags/lessons/ubuntu22.json \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy \
    --exclude asdf_groovy
  ```

## generate_ansible_vars.rb

### Ubuntu 22.04

These are some combinations you would try below:

* **A. Baseline (no flags)** — system ruby/python only, `groovy` via sdkman default:
  ```bash
  ./generate_ansible_vars.rb scriptbox/config/ubuntu2204.yml \
    ../../configbox/ansible/provision/group_vars/all/generated.yml
  ```
* **B. Traditional bundle** — `rbenv` + `pyenv` (covers python2 too, same tag) + `sdkman groovy`, explicit:
  ```bash
  ./generate_ansible_vars.rb scriptbox/config/ubuntu2204.yml \
    ../../configbox/ansible/provision/group_vars/all/generated.yml \
    --select rbenv,pyenv,sdkman_groovy
  ```
* **C. Full asdf** — verified this pulls in the asdf bootstrap + all three plugins/installs:
  ```bash
  ./generate_ansible_vars.rb scriptbox/config/ubuntu2204.yml \
    ../../configbox/ansible/provision/group_vars/all/generated.yml \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy
  ```
* **D. Mixed per-language **— `rbenv` for ruby, `asdf` for python, `sdkman` for groovy:
  ```bash
  ./generate_ansible_vars.rb scriptbox/config/ubuntu2204.yml \
    ../../configbox/ansible/provision/group_vars/all/generated.yml \
    --select rbenv,asdf_python,sdkman_groovy

  ```
* E. **Exclude/omission sanity check** — `asdf` minus groovy, so groovy has no active path at all (confirms --exclude vetoes and the omission comment fires cleanly instead of emitting a broken command):
  ```bash
  ./generate_ansible_vars.rb scriptbox/config/ubuntu2204.yml \
    ../../configbox/ansible/provision/group_vars/all/generated.yml \
    --select asdf,asdf_ruby,asdf_python,asdf_groovy \
    --exclude asdf_groovy
  ```
