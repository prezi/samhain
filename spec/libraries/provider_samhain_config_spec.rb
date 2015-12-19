# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_config'

describe Chef::Provider::SamhainConfig do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SamhainConfig.new(name, run_context) }
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
    let(:config) { nil }

    let(:new_resource) do
      r = super()
      r.config(config) unless config.nil?
      r
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:file)
    end

    context 'a nil config' do
      let(:config) { nil }

      it 'creates an empty config file' do
        p = provider
        expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
        expect(p).to receive(:owner).with('root')
        expect(p).to receive(:group).with('root')
        expect(p).to receive(:mode).with('0644')
        expect(p).to receive(:content).with(nil)
        p.action_create
      end
    end

    context 'an empty config' do
      let(:config) { {} }

      it 'creates an empty config file' do
        p = provider
        expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
        expect(p).to receive(:owner).with('root')
        expect(p).to receive(:group).with('root')
        expect(p).to receive(:mode).with('0644')
        expect(p).to receive(:content).with(nil)
        p.action_create
      end
    end

    context 'a populated config' do
      let(:config) { { 'Attributes' => { 'file' => { '/etc/mtab' => true } } } }

      it 'creates an populated config file' do
        p = provider
        expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
        expect(p).to receive(:owner).with('root')
        expect(p).to receive(:group).with('root')
        expect(p).to receive(:mode).with('0644')
        expect(p).to receive(:content).with("[Attributes]\nfile=/etc/mtab")
        p.action_create
      end
    end
  end

  describe '#action_remove' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:file)
    end

    it 'deletes the samhainrc config' do
      p = provider
      expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
      expect(p).to receive(:action).with(:delete)
      p.action_remove
    end
  end
end
