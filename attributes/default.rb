# we do not support Gerrit below 2.9
default['gerrit']['version'] = "2.9-rc1"
default['gerrit']['war']['download_url'] = "http://gerrit-releases.storage.googleapis.com/gerrit-#{node['gerrit']['version']}.war"

default['gerrit']['hostname'] = node['fqdn']

	
default['gerrit']['user'] = "gerrit"
default['gerrit']['group'] = "gerrit"
default['gerrit']['home'] = "/var/gerrit"
default['gerrit']['install_dir'] = "#{node['gerrit']['home']}/review"

default['gerrit']['proxy']['enable'] = true
default['gerrit']['proxy']['ssl'] = false

# These settings will end up in etc/gerrit.config
default['gerrit']['config']['gerrit']['basePath'] = "git"   # location of git repositories
default['gerrit']['config']['gerrit']['canonicalWebUrl'] = "http://#{node['gerrit']['hostname']}/"
default['gerrit']['config']['gerrit']['canonicalGitUrl'] = nil
default['gerrit']['config']['auth']['type'] = "OPENID"
default['gerrit']['config']['auth']['registerEmailPrivateKey'] = nil
default['gerrit']['config']['auth']['restTokenPrivateKey'] = nil
default['gerrit']['config']['sendemail']['smtpServer'] = "localhost"
default['gerrit']['config']['sshd']['listenAddress'] = "29418"
default['gerrit']['config']['database']['type'] = "h2"
default['gerrit']['config']['database']['database'] = node['gerrit']['config']['database']['type'] == "H2" ? "db/ReviewDB" : "gerrit"
default['gerrit']['config']['database']['hostname'] = "localhost"
default['gerrit']['config']['database']['username'] = "gerrit"
default['gerrit']['config']['database']['password'] = "gerrit"
default['gerrit']['config']['index']['type'] = "LUCENE"
default['gerrit']['config']['httpd']['listenUrl'] = "http://*:8080"

# these confidential attributes defined in gerrit_config will be shifted to etc/secure.config
default['gerrit']['secure_config']['database']['password'] = true
default['gerrit']['secure_config']['auth']['registerEmailPrivateKey'] = true
default['gerrit']['secure_config']['auth']['restTokenPrivateKey'] = true
default['gerrit']['secure_config']['ldap']['secureFoo'] = true


# When using MySql as a db for Gerrit, the Gerrit documentation recommends changing the db charset
# to latin1, in order to allow 1000 byte keys using the default MySQL MyISAM engine.  This can lead
# to spurious errors from Gerrit regarding "Illegal mix of collations".  We can avoid this by being
# explicit to the connector about which charset to use, by setting database.url in gerrit.config.
#
# One may use utf8 and avoid the key length limitation by switching to InnoDB, though we don't want
# to assume this choice.
default['gerrit']['database']['jdbc_url'] =
"jdbc:mysql://#{node['gerrit']['database']['host']}:3306" +
    "/#{node['gerrit']['database']['name']}?" +
    "user=#{node['gerrit']['database']['username']}&" +
    "password=#{node['gerrit']['database']['password']}&" +
    "useUnicode=false&characterEncoding=latin1"


# the core plugins that should be installed. Installation only works at site initialization.
default['gerrit']['core_plugins'] = ['replication', 'commit-message-length-validator', 'reviewnotes', 'download-commands']



# TODO I'm yet unsure, how to handle this in the future

# if this is set, an entry in the ssl_certificates data bag matching the given name must exist
# this uses the ssl-certificates cookbook
# http://github.com/binarymarbles/chef-ssl-certificates
default['gerrit']['ssl'] = false
default['gerrit']['ssl_certificate'] = nil


override['mysql']['bind_address'] = "127.0.0.1"



default['gerrit']['theme']['compile_files'] = []
default['gerrit']['theme']['static_files'] = []

default['gerrit']['peer_keys']['enabled'] = false
default['gerrit']['peer_keys']['public'] = ""
default['gerrit']['peer_keys']['private'] = ""

# Gerrit 2.9 requires Java 7
default['java']['jdk_version'] = 7 if node['java']['jdk_version'] < "7" && node['gerrit']['version'] >= "2.9"

