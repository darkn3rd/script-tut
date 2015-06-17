#
# Cookbook Name:: centos6box
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

shells   = %w{dash bash ksh tcsh}
script   = %w{gawk perl python php-cli ruby tcl}
packages = [shells, script]

packages.each do |pkg|
  package pkg do
    action :install
  end
end
