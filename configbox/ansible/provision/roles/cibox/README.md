cibox
=====

Installs and verifies CI tooling (Docker via `geerlingguy.docker`, then
`nektos/act` via `diodonfrost.act`) - runs `act --version`, then writes the
result to `cibox_verify_log` and shows it via `ansible.builtin.debug`.

The outlier of the three roles: unlike `lessons`/`scriptbox`, it's hand-wired
rather than driven by `scriptbox/config/*.yml` via `group_vars/all/
generated.yml` for now - see `scriptbox/config/ubuntu2204.yml`'s own
`cibox:` section, not yet consumed by `generate_ansible_vars.rb`.

Requirements
------------

- `geerlingguy.docker` and `diodonfrost.act` roles vendored into
  `../../.galaxy-vendor/roles/` first (`ansible-galaxy install -r
  ../../requirements.yml`) - see `../../ansible.cfg`'s `roles_path`

Role Variables
--------------

See `defaults/main.yml`:

- `cibox_user` (default `vagrant`) - who `act` runs as, and so needs
  docker-group membership for.
- `cibox_verify_log` (default `/tmp/cibox_verify.log`) - where the
  verification result is written on the target host.

Dependencies
------------

- `geerlingguy.docker` - installs Docker CE, act's own container runtime.
- `diodonfrost.act` - installs `act` itself.

Both run automatically before this role's own tasks (see `meta/main.yml`),
in that order - `act` needs Docker already running.

Example Playbook
----------------

    - hosts: all
      become: true
      roles:
        - cibox

License
-------

MPL-2.0

Author Information
-------------------

Joaquin Menchaca
