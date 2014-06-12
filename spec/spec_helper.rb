require 'chefspec'
require 'chefspec/berkshelf'
require 'chefspec/cacher'
require_relative 'helpers/matchers'

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

RSpec.configure do |config|

  # Specify the Chef log_level (default: :warn)
  config.log_level = :warn

  # Specify the operating platform to mock Ohai data from (default: nil)
  config.platform = 'debian'

  # Specify the operating version to mock Ohai data from (default: nil)
  config.version = '7.4'
end

#at_exit { ChefSpec::Coverage.report! }