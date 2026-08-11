#
# Cookbook Name:: scriptbox
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

packages = ""

if node[:platform_family].include?("rhel")
  # Package names tested on CentOS 6.6
  shells   = %w{dash bash ksh tcsh}
  script   = %w{gawk perl python php-cli ruby tcl}
  packages = [shells, script]
elsif node[:platform_family].include?("debian")
  # Package names tested on Debian 7.8
  shells   = %w{dash bash ksh tcsh}
  script   = %w{gawk perl python php5-cli ruby tcl8.5}
  packages = [shells, script]
end

packages.each do |pkg|
  package pkg do
    action :install
  end
end
