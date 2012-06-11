#
# Cookbook Name:: deploy_keys
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.projects.each do |project|
  template "/var/lib/jenkins/.ssh/id_#{project['slug']}" do
    source "ssh_key.erb"
    owner "jenkins"
    group "jenkins"
    mode "0600"
    variables :private_key => project['private_key']
  end
end

template "/var/lib/jenkins/.ssh/config" do
  source "ssh_config.erb"
  owner "jenkins"
  group "jenkins"
  mode "0600"
end