#
# Cookbook Name:: gerrit
# Recipe:: peer_keys
#
# Copyright 2012, Steffen Gebert / TYPO3 Association
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
require 'mixlib/shellout'
require 'json'

batch_admin_username = node['gerrit']['batch_admin_user']['username']

ssh_key_filename = "id_rsa-#{batch_admin_username}"
ssh_key_file = node['gerrit']['home'] + "/.ssh/" + ssh_key_filename

war_path = "#{node['gerrit']['home']}/war/gerrit-#{node['gerrit']['version']}.war"
  
execute "generate private ssh key for 'Gerrit Code Review' user" do
  command "ssh-keygen -t rsa -q -f #{ssh_key_file} -C\"{batch_admin_user}@#{node['gerrit']['hostname']}\""
  user node['gerrit']['user']
  group node['gerrit']['group']
  creates ssh_key_file
end

Chef::Recipe.send(:include, Gerrit::Helpers)
ruby_block "gerrit create batch_admin_user" do
  block do
    has_admin = ssh_can_connect?(batch_admin_username, "#{ssh_key_file}.pub", node['gerrit']['hostname'], 29418)
    
    unless has_admin then
      cmd = "java -jar #{war_path} gsql --format JSON -c 'SELECT * from accounts;' -d #{node['gerrit']['install_dir']}"
      select_account = Mixlib::ShellOut.new(cmd, :user => node['gerrit']['user'], :cwd => "#{node['gerrit']['home']}/war")
      select_account.run_command
      parsed = JSON.parse(select_account.stdout)
      puts parsed
      select_account.error!
    end
  end
end

#select_account = Mixlib::ShellOut.new("echo 'SELECT * from accounts;' | java -jar #{war_path} gsql -d #{node['gerrit']['install_dir']}")
ruby_block "gerrit fetch batch_admin_user" do
  block do
    
  end
end
#Chef::Application.fatal!("exit for now")
#execute "xxxgerrit fetch batch_admin_user" do
#  user node['gerrit']['user']
#  group node['gerrit']['group']
#  cwd "#{node['gerrit']['home']}/war"
#  command "echo 'SELECT * from accounts;' | java -jar #{war_path} gsql -d #{node['gerrit']['install_dir']}"
#  action :run
#  #notifies :restart, "service[gerrit]"
#end