#
# Cookbook Name:: gerrit
# Attributes:: default
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

# todo remove
default['gerrit']['flavor'] = "war"

default['gerrit']['version'] = "2.9.0-rc1"

default['gerrit']['war']['download_url'] = "http://gerrit-releases.storage.googleapis.com/gerrit-#{node['gerrit']['version']}.war"

# todo remove
default['gerrit']['source']['repository'] = "https://gerrit.googlesource.com/gerrit"

default['gerrit']['hostname'] = node['fqdn']


default['gerrit']['user'] = "gerrit"
default['gerrit']['group'] = "gerrit"
default['gerrit']['home'] = "/var/gerrit"
default['gerrit']['install_dir'] = "#{node['gerrit']['home']}/review"

# These settings will end up in etc/gerrit.config
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


default['gerrit']['proxy'] = true

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

