#
# Cookbook Name:: main
# Recipe:: default
#
# Copyright 2012, Michiel Sikkes
#

execute "apt-get update"

package "curl" do
  action :install
end

package "libxml2-dev" do
  action :install
end

package "libxslt1-dev" do
  action :install
end

include_recipe "vim"
include_recipe "mysql"
include_recipe "mysql::server"
include_recipe "databases"
include_recipe "git"
include_recipe "java"
include_recipe "jenkins"
include_recipe "jenkins-admin"