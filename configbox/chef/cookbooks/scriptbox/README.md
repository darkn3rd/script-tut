# scriptbox

Installs script-tut's own scriptbox tooling (apt packages, shell scripts,
rbenv-scoped gems) from data bag items generated out of
`scriptbox/config/*.yml` by `scriptbox/scripts/generate_chef_databag.rb`.
Chef analogue of the `scriptbox` Ansible role.

## Requirements

- Ubuntu node (`supports 'ubuntu'`)
- Assumes an apt cache update already ran earlier in the run list (see
  `../../systems/ubuntu2204/Vagrantfile` - `lessons` runs first and does
  this)
- rbenv already installed under `node['scriptbox']['user']`'s home (the
  `gem` steps target rbenv's own rubygems, not the system one)

## Attributes

See `attributes/default.rb`:

- `node['scriptbox']['platform']` (default `ubuntu22`) - selects which
  `data_bags/scriptbox/*.json` item to converge against. Only `ubuntu22`
  exists today.
- `node['scriptbox']['user']` (default `vagrant`) - whose rbenv gem
  installs the `gem` steps target.

## Example Run List

    run_list 'recipe[lessons]', 'recipe[scriptbox]'

See `../../systems/ubuntu2204/Vagrantfile` for a working end-to-end
example (`chef.add_recipe "scriptbox"`).

## License

MPL-2.0
