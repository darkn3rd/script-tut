# lessons

Installs the language interpreters, compilers, and per-lesson tooling used
in Lessons, from data bag items generated out of `scriptbox/config/*.yml`
by `scriptbox/scripts/generate_chef_databag.rb`. Chef analogue of the
`lessons` Ansible role.

## Requirements

- Ubuntu or Windows node (`supports 'ubuntu'`, `supports 'windows'`)
- Cookbook dependencies (see `metadata.rb`): `pyenv`, `ruby_rbenv`, `perl`,
  `line`, `chocolatey`

## Attributes

See `attributes/default.rb`:

- `node['lessons']['platform']` (default `ubuntu22`) - selects which
  `data_bags/lessons/*.json` item to converge against. Only `ubuntu22`
  exists today.
- `node['lessons']['user']` (default `vagrant`) - owner of per-user
  installs (rustup, pyenv, rbenv, ...) and their home directory.
- `node['lessons']['gen_scripts']`, `node['lessons']['shell_scripts']`,
  `node['lessons']['compiled_lang']`, `node['lessons']['win_scripts']`
  (all default `true`) - per-area gates; the data bag's `common` steps
  always run regardless.

## Recipes

- `default` - runs `common` steps, then includes each area recipe below
  if its gate attribute is true
- `gen_scripts`, `shell_scripts`, `compiled_lang`, `win_scripts` - one per
  area, driven by `install_step`/`lessons_install` in
  `libraries/helpers.rb`

## Example Run List

    run_list 'recipe[lessons]'

See `../../systems/ubuntu2204/Vagrantfile` for a working end-to-end
example (`chef.add_recipe "lessons"`).

## License

MPL-2.0
