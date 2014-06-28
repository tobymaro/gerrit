#
# Cookbook Name:: gerrit
# Library:: helpers
#
# Copyright 2014, TYPO3 Association
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


module Gerrit
  module Helpers

    # Checks against the current gerrit version
    #
    # @return [Boolean]
    def gerrit_above?(version)
      require 'chef/version_constraint'

      # remove the garbage (like -rc1 etc.) from version numbers
      actual_version_cleaned = node['gerrit']['version'].split('-')[0]
      Chef::VersionConstraint.new(">= #{version}").include?(actual_version_cleaned)
    end

    # Checks if SSH connection succeeeds
    #
    # @return [Boolean]
    def ssh_can_connect?(user, key, host, port)
      ssh = Mixlib::ShellOut.new("ssh -o StrictHostKeyChecking=no -i #{key} -p #{port} -l #{user} #{host}")
      ssh.run_command
      # return true if there was no error
      ! error?
    end

  end
end

Chef::Node::Attribute.send(:include, ::Gerrit::Helpers)
Chef::Recipe.send(:include, ::Gerrit::Helpers)
Chef::Resource.send(:include, ::Gerrit::Helpers)
Chef::Provider.send(:include, ::Gerrit::Helpers)
