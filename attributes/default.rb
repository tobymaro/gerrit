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

default['gerrit']['version'] = "full-2.5-rc0"
default['gerrit']['checksum'] = {
  '2.2.1' => "8af3c50c8b",
  'full-2.5-rc0' => "9c9d3ed1f87c"
}

default['gerrit']['user'] = "gerrit"
default['gerrit']['group'] = "gerrit"
default['gerrit']['home'] = "/var/gerrit"

default['gerrit']['install_dir'] = "#{node['gerrit']['home']}/review"

default['gerrit']['hostname'] = node['fqdn']
default['gerrit']['port'] = "29418"
default['gerrit']['frontend_url'] = "http://#{node['fqdn']}:8080/"

default['gerrit']['database']['host'] = "localhost"
default['gerrit']['database']['name'] = "gerrit"
default['gerrit']['database']['username'] = "gerrit"
default['gerrit']['database']['password'] = "fooooooo"

if platform?("debian")
  if node['lsb']['codename'] =~ /wheezy/
    # default['java']['jdk_version'] = "7"
    default['java']['java_home'] = "/usr/lib/jvm/java-6-openjdk-amd64"
  else
    default['java']['java_home'] = "/usr/lib/jvm/java-6-openjdk"
  end
end