####################################
# Deploy
####################################

include_recipe "git"

filename = "#{node['gerrit']['home']}/war/gerrit-#{node['gerrit']['version']}.war"

remote_file filename do
  owner node['gerrit']['user']
  source node['gerrit']['war']['download_url']
  # checksum node['gerrit']['war']['checksum'][node['gerrit']['version']]
  notifies :run, "execute[gerrit-init]", :immediately
  notifies :run, "execute[gerrit-reindex]", :immediately if node['gerrit']['version'] >= "2.9"
  action :create_if_missing
end

####################################
# Core Plugins
####################################

# we have to explicitly list the core plugins that should be installed
plugin_command = ""
node['gerrit']['core_plugins'].each do |plugin|
  plugin_command << "  --install-plugin #{plugin}"
end

####################################
# Gerrit init
####################################

execute "gerrit-init" do
  user node['gerrit']['user']
  group node['gerrit']['group']
  cwd "#{node['gerrit']['home']}/war"
  command "java -jar #{filename} init --batch --no-auto-start -d #{node['gerrit']['install_dir']} #{plugin_command}"
  action :nothing
  notifies :restart, "service[gerrit]"
end

execute "gerrit-reindex" do
  user node['gerrit']['user']
  group node['gerrit']['group']
  cwd "#{node['gerrit']['home']}/war"
  command "java -jar #{filename} reindex -d #{node['gerrit']['install_dir']}"
  action :nothing
end

link "/etc/init.d/gerrit" do
  to "#{node['gerrit']['install_dir']}/bin/gerrit.sh"
end

# this is a relict from an old version of the cookbook that prevented gerrit
# to start during system bootup and should be removed.
# see https://github.com/TYPO3-cookbooks/gerrit/pull/17
link "/etc/rc3.d/S90gerrit" do
  to "../init.d/gerrit"
  action :delete
end

# this should be moved to a later point, when all our configuration is written
service "gerrit" do
  supports :status => false, :restart => true, :reload => true
  action [ :enable, :start ]
end


####################################
# Static files
####################################

node['gerrit']['theme']['compile_files'].each do |file|
  cookbook_file "#{node['gerrit']['install_dir']}/etc/#{file}" do
    source "gerrit/#{file}"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
  end
end

node['gerrit']['theme']['static_files'].each do |file|
  cookbook_file node['gerrit']['install_dir'] + "/static/" + file do
    source "gerrit/static/" + file
    owner node['gerrit']['user']
    group node['gerrit']['group']
  end
end
