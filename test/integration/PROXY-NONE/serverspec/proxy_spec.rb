require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS


describe 'service apache2 httpd' do
  it 'should NOT be running' do
    puts "OS: #{RSpec.configuration.os.to_s}"
    case RSpec.configuration.os[:family]
      when "Debian"
        @service_name = 'apache2'
      when "Ubuntu"
        @service_name = 'apache2'
      else
        @service_name = 'httpd'
    end
    expect(service @service_name).not_to be_running
  end

  it 'should listen to port 80' do
    expect(port 80).not_to be_listening
  end
end
