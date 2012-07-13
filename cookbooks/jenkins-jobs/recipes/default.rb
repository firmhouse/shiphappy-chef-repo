#
# Cookbook Name:: jenkins-jobs
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.projects.each do |project|
  directory "/var/lib/jenkins/jobs/#{project['slug']}" do
    recursive true
    group "jenkins"
    owner "jenkins"
    mode "0755"
    action :create
  end
  
  template "/var/lib/jenkins/jobs/#{project['slug']}/config.xml" do
    source "jenkins_job.erb"
    owner "jenkins"
    group "jenkins"
    mode "0644"
    variables :slug => project['slug'], :deploy_url => project['deploy_url']
  end
end

execute "curl -X POST http://admin:admin@localhost/reload" do
  group "jenkins"
  user "jenkins"
end