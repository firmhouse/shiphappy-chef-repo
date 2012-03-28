#
# Cookbook Name:: databases
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.databases.each do |database|
  bash "create #{database} database" do
    not_if("mysql -uroot -p#{node['mysql']['server_root_password']} -e'show databases' | grep #{database}")
    
    code <<-CREATE_DATABASE
    mysql -uroot -p#{node['mysql']['server_root_password']} -e 'create database #{database}'
    CREATE_DATABASE
  end
end