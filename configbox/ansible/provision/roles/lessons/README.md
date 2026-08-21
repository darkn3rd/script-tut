lessons
=======

Installs the language interpreters, compilers, and per-lesson tooling used
in Lessons, from data generated out of `scriptbox/config/*.yml` by
`scriptbox/scripts/generate_ansible_vars.rb`. Ansible analogue of the
`lessons` Chef cookbook.

Requirements
------------

- Debian/Ubuntu target (`apt` tasks are gated on `ansible_facts['os_family']
  == 'Debian'`)
- `community.general` collection (`cpanm` module) - see
  `../../requirements.yml`
- `../../group_vars/all/generated.yml` present in the play (auto-loaded by
  Ansible - no include needed, but this role isn't self-contained outside
  `../../site.yml`'s own play)

Role Variables
--------------

See `defaults/main.yml`:

- `lessons_platform` (default `ubuntu22`) - selects which entry of
  `../../group_vars/all/generated.yml`'s `lessons:` map to converge
  against. Only `ubuntu22` exists today.
- `lessons_user` (default `vagrant`) - owner of per-user installs (rustup,
  pyenv, rbenv, ...) and their home directory.
- `lessons_gen_scripts`, `lessons_shell_scripts`, `lessons_compiled_lang`,
  `lessons_win_scripts` (all default `true`) - per-area gates; the manifest's
  `common` steps always run regardless.

Dependencies
------------

None.

Example Playbook
----------------

    - hosts: all
      become: true
      roles:
        - lessons

License
-------

MPL-2.0

Author Information
-------------------

Joaquin Menchaca
