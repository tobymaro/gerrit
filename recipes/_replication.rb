if node['gerrit'].attribute?('replication')
  remote_file "#{node['gerrit']['home']}/review/plugins/replication.jar" do
    owner node['gerrit']['user']
    source node['gerrit']['replication']['plugin_download_url']
    action :create_if_missing
  end

  template "#{node['gerrit']['install_dir']}/etc/replication.config" do
    source "gerrit/replication.config"
    owner node['gerrit']['user']
    group node['gerrit']['group']
    mode 0644
    notifies :restart, "service[gerrit]"
  end
end
