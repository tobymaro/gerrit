require 'spec_helper'

describe 'gerrit::default' do

  let(:install_dir)      { '/var/gerrit' }
  let(:user)             { 'gerrit' }

  cached(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['gerrit']['install_dir'] = install_dir
      node.set['gerrit']['config']['auth']['registerEmailPrivateKey'] = "123"
      node.set['gerrit']['config']['auth']['restTokenPrivateKey'] = "123"
    end.converge(described_recipe)
  end

  it 'creates the directory' do
    expect(chef_run).to create_directory(install_dir)
      .with_owner(user)
  end

  it 'installs openjdk-7-jdk' do
    expect(chef_run).to install_package('openjdk-7-jdk')
  end

  it 'enables and starts the service' do
    expect(chef_run).to enable_service('gerrit')
    expect(chef_run).to start_service('gerrit')
  end

end
