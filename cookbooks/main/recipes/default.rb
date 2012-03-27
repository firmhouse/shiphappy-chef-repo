#
# Cookbook Name:: main
# Recipe:: default
#
# Copyright 2012, Michiel Sikkes
#

include_recipe "mysql"
include_recipe "git"
include_recipe "java"
include_recipe "jenkins"
include_recipe "jenkins-admin"