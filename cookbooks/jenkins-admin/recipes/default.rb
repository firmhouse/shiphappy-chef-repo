#
# Cookbook Name:: jenkins-admin
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

pid_file = "/var/run/jenkins/jenkins.pid"

#"jenkins stop" may (likely) exit before the process is actually dead
#so we sleep until nothing is listening on jenkins.server.port (according to netstat)
ruby_block "netstat" do
  block do
    10.times do
      if IO.popen("netstat -lnt").entries.select { |entry|
          entry.split[3] =~ /:#{node[:jenkins][:server][:port]}$/
        }.size == 0
        break
      end
      Chef::Log.debug("service[jenkins] still listening (port #{node[:jenkins][:server][:port]})")
      sleep 1
    end
  end
  action :nothing
end

service "jenkins" do
  supports [ :stop, :start, :restart, :status ]
  status_command "test -f #{pid_file} && kill -0 `cat #{pid_file}`"
  action :nothing
end

ruby_block "block_until_operational" do
  block do
    until IO.popen("netstat -lnt").entries.select { |entry|
        entry.split[3] =~ /:#{node[:jenkins][:server][:port]}$/
      }.size == 1
      Chef::Log.debug "service[jenkins] not listening on port #{node.jenkins.server.port}"
      sleep 1
    end

    loop do
      url = URI.parse("#{node.jenkins.server.url}/login")
      res = Chef::REST::RESTRequest.new(:GET, url, nil).call
      break if res.kind_of?(Net::HTTPSuccess) or res.kind_of?(Net::HTTPNotFound)
      Chef::Log.debug "service[jenkins] not responding OK to GET / #{res.inspect}"
      sleep 1
    end
  end
  action :nothing
end

  directory "/var/lib/jenkins/users/api" do
    recursive true
    owner "jenkins"
    group "jenkins"
  end

  template "/var/lib/jenkins/users/api/config.xml" do
    source "api.xml.erb"
    mode 0660
    owner "jenkins"
    group "jenkins"
  end

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