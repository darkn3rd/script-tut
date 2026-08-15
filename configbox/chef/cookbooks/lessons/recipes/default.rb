# Cookbook:: lessons
# Recipe:: default
#
# Gates each area recipe on its own boolean attribute (all default true
#  - see ../attributes/default.rb) so a converge can skip an entire area
#  without touching this recipe or any of the area recipes themselves.

apt_update 'update' if platform_family?('debian')

%w[gen_scripts shell_scripts compiled_lang win_scripts].each do |area|
  include_recipe "lessons::#{area}" if node['lessons'][area]
end
