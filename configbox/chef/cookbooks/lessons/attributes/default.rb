# Which data bag item (see ../../data_bags/lessons/*.json) this node
#  converges against - one item per platform, generated from that
#  platform's own scriptbox/config/*.yml manifest.
default['lessons']['platform'] = 'ubuntu22'

# Which user per-user installs (e.g. rustup - see ../libraries/
#  helpers.rb's own SPECIAL_SCRIPTS) run as, and whose home directory
#  they land in. 'vagrant' matches every Vagrant box this cookbook is
#  currently converged against; override per node for anything else.
default['lessons']['user'] = 'vagrant'

# Area gates - all default true. Override on a node/role/environment,
#  or with -o at converge time, to skip an area entirely, e.g.:
#  chef-client -z -o 'recipe[lessons]' -j attrs.json
#  where attrs.json sets lessons.win_scripts to false.
default['lessons']['gen_scripts'] = true
default['lessons']['shell_scripts'] = true
default['lessons']['compiled_lang'] = true
default['lessons']['win_scripts'] = true
