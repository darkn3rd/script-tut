# Cookbook:: lessons
# Recipe:: default
#
# Gates each area recipe on its own boolean attribute (all default true
#  - see ../attributes/default.rb) so a converge can skip an entire area
#  without touching this recipe or any of the area recipes themselves.

apt_update 'update' if platform_family?('debian')

# 'common' - steps that live directly on the manifest's own lessons.
#  packages, not nested under any one of the four gated areas below (see
#  scriptbox/scripts/generate_chef_databag.rb's own COMMON_AREA) - e.g.
#  the sdkman bootstrap, which gen_scripts's own `sdkman: groovy` step
#  depends on existing already. Always runs, ungated - it's shared setup,
#  not an area a converge would want to skip on its own.
platform_data = data_bag_item('lessons', node['lessons']['platform'])
Array(platform_data['common']).each { |pkg| lessons_install(pkg) }

%w[gen_scripts shell_scripts compiled_lang win_scripts].each do |area|
  include_recipe "lessons::#{area}" if node['lessons'][area]
end
