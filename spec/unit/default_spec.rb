require 'spec_helper'

describe 'ds_chef_server_populator::default' do
  let(:chef_solo_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  let(:chef_client_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ds_chef_server_populator::solo')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ds_chef_server_populator::client')
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ds_chef_server_populator::restore')
  end

  context 'when running under chef-solo' do
    it 'includes solo recipe' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ds_chef_server_populator::solo')
      chef_solo_run
    end
  end

  context 'when running under chef-client' do
    it 'includes client recipe' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ds_chef_server_populator::client')
      chef_client_run
    end
  end

  context 'when provided values for restore file attribute' do
    it 'includes restore recipe' do
      chef_solo_run.node.override['chef_server_populator']['restore']['file'] = '/tmp/latest.tgz'
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('ds_chef_server_populator::restore')
      chef_solo_run.converge(described_recipe)
    end
  end
end
