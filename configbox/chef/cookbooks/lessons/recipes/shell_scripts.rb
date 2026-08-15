# Cookbook:: lessons
# Recipe:: shell_scripts
#
# Static - never edited when the manifest/data bag changes. See
#  ./gen_scripts.rb's own comment for where the data actually comes from.

platform_data = data_bag_item('lessons', node['lessons']['platform'])
platform_data['shell_scripts'].each { |pkg| lessons_install(pkg) }
