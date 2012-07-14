#
# Cookbook Name:: jenkins-admin
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "/var/lib/jenkins/users/admin" do
  recursive true
  owner "jenkins"
  group "jenkins"
end

template "/var/lib/jenkins/users/admin/config.xml" do
  source "admin.xml.erb"
  mode 0660
  owner "jenkins"
  group "jenkins"
end

template "/var/lib/jenkins/config.xml" do
  source "jenkins_config.xml.erb"
  mode 0660
  owner "jenkins"
  group "jenkins"
end

template "/var/lib/jenkins/.ssh/config" do
  source "jenkins_ssh_config.erb"
  mode "0660"
  owner "jenkins"
  group "jenkins"
end

template "/var/lib/jenkins/.gitconfig" do
  source "jenkins_git_config.erb"
  mode "0660"
  owner "jenkins"
  group "jenkins"
end

template "/var/lib/jenkins/.gemrc" do
  source "gemrc.erb"
  mode "0660"
  owner "jenkins"
  group "jenkins"
end

log "Restarting Jenkins for new admin user..." do
  notifies :stop, "service[jenkins]", :immediately
  notifies :create, "ruby_block[netstat]", :immediately
  notifies :start, "service[jenkins]", :immediately
  notifies :create, "ruby_block[block_until_operational]", :immediately
end