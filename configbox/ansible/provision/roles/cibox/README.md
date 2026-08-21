cibox
=====

Installs and verifies CI tooling (`nektos/act`, via the vendored
`diodonfrost.act` Galaxy role) - runs `act --version`, then writes the
result to `cibox_verify_log` and shows it via `ansible.builtin.debug`.

Requirements
------------

- `diodonfrost.act` role vendored into `../../.galaxy-vendor/roles/` first
  (`ansible-galaxy install -r ../../requirements.yml`) - see
  `../../ansible.cfg`'s `roles_path`

Role Variables
--------------

See `defaults/main.yml`:

- `cibox_verify_log` (default `/tmp/cibox_verify.log`) - where the
  verification result is written on the target host.

Dependencies
------------

- `diodonfrost.act` (see `meta/main.yml`) - installs `act` itself; runs
  automatically before this role's own tasks.

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
