require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require_relative 'helpers/matchers'

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

#at_exit { ChefSpec::Coverage.report! }
