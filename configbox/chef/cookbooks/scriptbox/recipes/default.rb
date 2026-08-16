# Cookbook:: scriptbox
# Recipe:: default
#
# Static - never edited when the manifest/data bag changes. All content
#  comes from data_bags/scriptbox/<platform>.json (see node['scriptbox']
#  ['platform'] - ../attributes/default.rb), generated from scriptbox/
#  config/*.yml's own scriptbox: section by scriptbox/scripts/
#  generate_scriptbox_databag.rb.
#
# No apt_update here - lessons::default already runs one, and it stays
#  valid for the rest of this same chef-client run; scriptbox always
#  converges alongside lessons (see the Vagrantfile's own run_list,
#  lessons added first), not standalone.

platform_data = data_bag_item('scriptbox', node['scriptbox']['platform'])
platform_data['packages'].each { |pkg| scriptbox_install(pkg) }
