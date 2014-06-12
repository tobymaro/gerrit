require 'spec_helper'

describe 'gerrit::proxy' do

  let(:install_dir)      { '/var/gerrit' }
  let(:user)             { 'gerrit' }
  let(:hostname)         { 'gerrit.chefspec.local'}

  # dont use cached chef_run!!! It will break the test because the custom matcher does not pick up the changes!
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['gerrit']['install_dir'] = install_dir
      #node.set['gerrit']['proxy']['enable'] = false
      node.set['gerrit']['hostname'] = hostname
    end.converge(described_recipe)
  end

  it 'create apache proxy without ssl' do
    expect(chef_run).to enable_apache_web_app("#{hostname}").with(
      ssl_certfile: nil,
      ssl_keyfile: nil,
      ssl_cabundle: nil
     )
  end
  
  it 'create apache proxy with default ssl attributes' do
    chef_run.node.set['gerrit']['ssl'] = true
    chef_run.converge(described_recipe) # The converge happens inside the test
    expect(chef_run).to enable_apache_web_app("#{hostname}").with(
      ssl_certfile: "/etc/ssl/certs/ssl-cert-snakeoil.pem",
      ssl_keyfile: "/etc/ssl/private/ssl-cert-snakeoil.key",
      ssl_cabundle: nil
    )
  end
end
