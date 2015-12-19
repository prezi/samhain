# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain'

describe Chef::Provider::Samhain do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::Samhain.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '.provides?' do
    let(:platform) { nil }
    let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
    let(:res) { described_class.provides?(node, new_resource) }

    context 'Ubuntu' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end
  end

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_create' do
    before(:each) do
      [:samhain_app, :samhain_config, :samhain_service].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'installs the Samhain app' do
      p = provider
      expect(p).to receive(:samhain_app).with(name).and_yield
      expect(p).to_not receive(:source)
      p.action_create
    end

    it 'creates a Samhain config' do
      p = provider
      expect(p).to receive(:samhain_config).with(name).and_yield
      expect(p).to_not receive(:config)
      expect(p).to receive(:notifies).with(:reload, "samhain_service[#{name}]")
      p.action_create
    end

    it 'enables and starts the Samhain service' do
      p = provider
      expect(p).to receive(:samhain_service).with(name)
      p.action_create
    end
  end

  describe '#action_remove' do
    before(:each) do
      [:samhain_service, :samhain_config, :samhain_app].each do |m|
        allow_any_instance_of(described_class).to receive(m)
      end
    end

    it 'stops, disables, and removes the Samhain service' do
      p = provider
      expect(p).to receive(:samhain_service).with(name).and_yield
      expect(p).to receive(:action).with([:stop, :disable, :remove])
      p.action_remove
    end

    it 'removes the Samhain config' do
      p = provider
      expect(p).to receive(:samhain_config).with(name).and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end

    it 'removes the Samhain app' do
      p = provider
      expect(p).to receive(:samhain_app).with(name).and_yield
      expect(p).to receive(:action).with(:remove)
      p.action_remove
    end
  end
end
