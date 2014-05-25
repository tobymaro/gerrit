if node['gerrit']['config']['database']['type'] == "MYSQL"
  include_recipe "gerrit::mysql"
elsif node['gerrit']['config']['database']['type'] == "POSTGRESQL"
  include_recipe "gerrit::postgresql"
end