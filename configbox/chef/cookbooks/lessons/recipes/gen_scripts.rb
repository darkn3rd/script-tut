# Cookbook:: lessons
# Recipe:: gen_scripts
#
# Static - never edited when the manifest/data bag changes. All content
#  comes from data_bags/lessons/<platform>.json (see node['lessons']
#  ['platform'] - ../attributes/default.rb), generated from scriptbox/
#  config/*.yml by scriptbox/scripts/generate_chef_databag.rb.

platform_data = data_bag_item('lessons', node['lessons']['platform'])

# perl cookbook's own default recipe installs perl + bootstraps cpanm -
#  a prerequisite for cpan_module (see ../libraries/helpers.rb's own
#  'cpan'/'cpanm' dispatch), not something cpan_module sets up itself.
#  Only included if this platform's data actually has a cpan/cpanm step,
#  so a platform with neither doesn't pull in perl's own package install
#  for nothing.
if platform_data['gen_scripts'].any? { |pkg| %w[cpan cpanm].include?(pkg['type']) }
  include_recipe 'perl'
end

platform_data['gen_scripts'].each { |pkg| lessons_install(pkg) }
