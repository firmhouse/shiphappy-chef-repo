#
# Cookbook Name:: packages
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.packages.each do |package_name|
  package package_name
end