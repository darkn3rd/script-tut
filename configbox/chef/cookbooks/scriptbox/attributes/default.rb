# Which data bag item (see ../../data_bags/scriptbox/*.json) this node
#  converges against - one item per platform, generated from that
#  platform's own scriptbox/config/*.yml manifest's scriptbox: section.
default['scriptbox']['platform'] = 'ubuntu22'

# Which user's rbenv-managed ruby scriptbox's own gem install/update
#  steps target - see ../libraries/helpers.rb's own 'gem'/SPECIAL_CMDS
#  cases. 'vagrant' matches every Vagrant box this cookbook currently
#  converges against; override per node for anything else.
default['scriptbox']['user'] = 'vagrant'
