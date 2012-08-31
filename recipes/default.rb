#
# Cookbook Name:: gerrit
# Recipe:: default
#
# Copyright 2011, Myplanet Digital
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

####################################
# User setup
####################################

group node['gerrit']['group']

user node['gerrit']['user'] do
  gid node['gerrit']['group']
  home node['gerrit']['home']
  comment "Gerrit system user"
  shell "/bin/bash"
end

directory node['gerrit']['home'] do
  owner node['gerrit']['user']
  group node['gerrit']['group']
  recursive true
end


####################################
# MySQL
####################################

require_recipe "build-essential"
require_recipe "mysql"
require_recipe "mysql::server"
require_recipe "database"

mysql_connection_info = {
    :host =>  "localhost",
    :username => "root",
    :password => node['mysql']['server_root_password']
  }

mysql_database node['gerrit']['database']['name'] do
  connection mysql_connection_info
  action :create
end

mysql_database "changing the charset of database" do
  connection mysql_connection_info
  database_name node['gerrit']['database']['name']
  action :query
  sql "ALTER DATABASE #{node['gerrit']['database']['name']} charset=latin1"
end

mysql_database_user node['gerrit']['database']['username'] do
  connection mysql_connection_info
  password node['gerrit']['database']['password']
  action :create
end

mysql_database_user node['gerrit']['database']['username'] do
  connection mysql_connection_info
  database_name node['gerrit']['database']['name']
  privileges [
    :all
  ]
  action :grant
end

mysql_database "flushing mysql privileges" do
  connection mysql_connection_info
  action :query
  sql "FLUSH PRIVILEGES"
end


####################################
# Deploy
####################################

require_recipe "java"
require_recipe "git"

remote_file "#{Chef::Config[:file_cache_path]}/gerrit.war" do
  owner node['gerrit']['user']
  source "http://gerrit.googlecode.com/files/gerrit-#{node['gerrit']['version']}.war"
  checksum node['gerrit']['checksum'][node['gerrit']['version']]
end

directory node['gerrit']['install_dir'] do
  owner node['gerrit']['user']
  owner node['gerrit']['group']
  mode "0700"
  recursive true 
end

directory "#{node['gerrit']['install_dir']}/etc" do
  owner node['gerrit']['user']
  owner node['gerrit']['group']
  mode "0700"
end

template "#{node['gerrit']['install_dir']}/etc/gerrit.config" do
  source "gerrit.config"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0600
end

template "#{node['gerrit']['install_dir']}/etc/secure.config" do
  source "secure.config"
  owner node['gerrit']['user']
  group node['gerrit']['group']
  mode 0600
end

bash "Initializing Gerrit site" do
  user node['gerrit']['user']
  group node['gerrit']['group']
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
  java -jar gerrit.war init --batch --no-auto-start -d #{node['gerrit']['install_dir']}
  EOH
end

template "/etc/default/gerritcodereview" do
  source "default.gerritcodereview.erb"
end

link "/etc/init.d/gerrit" do
  to "#{node['gerrit']['install_dir']}/bin/gerrit.sh"
end

link "/etc/rc3.d/S90gerrit" do
  to "../init.d/gerrit"
end

service "gerrit" do
  supports :status => false, :restart => true, :reload => true
  action [ :enable, :start ]
end