#
# Cookbook Name:: configuration
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "phantomjs"

require_recipe "databases"
require_recipe "deploy_keys"
require_recipe "packages"
require_recipe "jenkins-jobs"