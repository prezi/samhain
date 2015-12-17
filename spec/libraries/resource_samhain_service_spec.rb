# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/resource_samhain_service'

describe Chef::Resource::SamhainService do
  let(:name) { 'default' }
  let(:resource) { described_class.new(name, nil) }

  describe '#initialize' do
    it 'sets the correct resource name' do
      expect(resource.resource_name).to eq(:samhain_service)
    end

    it 'sets the correct supported actions' do
      expected = [:nothing, :enable, :disable, :start, :stop, :restart, :reload,
                  :create, :remove]
      expect(resource.allowed_actions).to eq(expected)
    end

    it 'sets the correct default action' do
      expect(resource.action).to eq([:create, :enable, :start])
    end
  end
end
