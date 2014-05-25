####################################
# User setup
####################################

group node['gerrit']['group']

user node['gerrit']['user'] do
  gid node['gerrit']['group']
  home node['gerrit']['home']
  comment "Gerrit system user"
  shell "/bin/bash"
  system true
end


####################################
# Directories & Files
####################################

dirs = [
  node['gerrit']['home'],
  node['gerrit']['home'] + "/war",
  node['gerrit']['install_dir'],
  node['gerrit']['install_dir'] + "/etc",
  node['gerrit']['install_dir'] + "/lib",
  node['gerrit']['install_dir'] + "/static",
  node['gerrit']['install_dir'] + "/plugins"
]

dirs.each do |dir|
  directory dir do
    owner node['gerrit']['user']
    group node['gerrit']['group']
    recursive true
  end
end

####################################
# /etc/default
####################################

template "/etc/default/gerritcodereview" do
  source "system/default.gerritcodereview.erb"
  mode 0644
  notifies :restart, "service[gerrit]"
end
