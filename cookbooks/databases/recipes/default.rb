#
# Cookbook Name:: databases
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

ruby_block "create_databases_when_mysql_live" do
  block do
    loop do
      break if File.exists?('/var/run/mysqld/mysqld.pid')
    end
  end
end

node.databases.each do |database|
  bash "create #{database} database" do
    not_if("mysql -uroot -p#{node['mysql']['server_root_password']} -e'show databases' | grep #{database}")

    code <<-CREATE_DATABASE
    mysql -uroot -p#{node['mysql']['server_root_password']} -e 'create database #{database}'
    CREATE_DATABASE
  end
end