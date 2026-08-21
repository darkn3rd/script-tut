scriptbox
=========

Installs script-tut's own scriptbox tooling (apt packages, shell scripts,
rbenv-scoped gems, pipx tools) from data generated out of
`scriptbox/config/*.yml` by `scriptbox/scripts/generate_ansible_databag.rb`.
Ansible analogue of the `scriptbox` Chef cookbook.

Requirements
------------

- Debian/Ubuntu target
- Assumes an apt cache update already ran earlier in the same play (see
  `../../site.yml` - `lessons` runs first and does this)
- rbenv already installed under `scriptbox_user`'s home (the `gem` steps
  target rbenv's own rubygems, not the system one)

Role Variables
--------------

See `defaults/main.yml`:

- `scriptbox_platform` (default `ubuntu22`) - selects which generated
  `vars/<platform>.yml` to converge against. Only `ubuntu22` exists today.
- `scriptbox_user` (default `vagrant`) - whose rbenv/pipx installs the `gem`
  and `pipx` steps target.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: all
      become: true
      roles:
        - lessons
        - scriptbox

License
-------

MPL-2.0

Author Information
-------------------

Joaquin Menchaca
