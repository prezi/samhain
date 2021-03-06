# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_service'

describe Chef::Provider::SamhainService do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) do
    Chef::Resource::SamhainService.new(name, run_context)
  end
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

  [:enable, :disable, :start, :stop, :restart, :reload].each do |a|
    describe "#action_#{a}" do
      it 'passes the action on to the samhain_service method' do
        p = provider
        expect(p).to receive(:samhain_service).with(a)
        p.send("action_#{a}")
      end
    end
  end

  describe '#action_create' do
    it 'does nothing' do
      p = provider
      expect(p).to_not receive(:service)
      expect(p).to_not receive(:file)
      p.action_create
    end
  end

  describe '#action_remove' do
    it 'deletes the Samhain service definition' do
      p = provider
      expect(p).to receive(:file).with('/etc/init.d/samhain').and_yield
      expect(p).to receive(:action).with(:delete)
      p.action_remove
    end
  end

  describe '#samhain_service' do
    [:enable, :start, [:stop, :disable]].each do |a|
      context "'#{a}' action(s)" do
        it 'passes the action(s) on to a service resource' do
          p = provider
          expect(p).to receive(:service).with('samhain').and_yield
          expect(p).to receive(:supports).with(restart: true,
                                               reload: true,
                                               status: true)
          expect(p).to receive(:action).with(a)
          p.send(:samhain_service, a)
        end
      end
    end
  end
end
