#
# Cookbook Name:: wheezybox
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

shells   = %w{dash bash ksh tcsh}
script   = %w{gawk perl python php5-cli ruby tcl8.5}
packages = [shells, script]

packages.each do |pkg|
  package pkg do
    action :install
  end
end
