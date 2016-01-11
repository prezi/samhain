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
    let(:log_group_writable?) { false }
    let(:log_write_users) { [] }
    let(:config) { nil }

    let(:new_resource) do
      r = super()
      r.config(config) unless config.nil?
      r
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:file)
      allow(SamhainCookbook::Helpers).to receive(:group_writable?)
        .and_return(log_group_writable?)
      allow(SamhainCookbook::Helpers).to receive(
        :users_with_group_write_access_for
      ).and_return(log_write_users)
    end

    context 'a nil config' do
      let(:config) { nil }

      it 'creates an empty config file' do
        p = provider
        expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
        expect(p).to receive(:owner).with('root')
        expect(p).to receive(:group).with('root')
        expect(p).to receive(:mode).with('0644')
        expect(p).to receive(:lazy).and_yield
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
        expect(p).to receive(:lazy).and_yield
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
        expect(p).to receive(:lazy).and_yield
        expect(p).to receive(:content).with("[Attributes]\nfile=/etc/mtab")
        p.action_create
      end
    end

    context 'a group-writable log directory' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }
      let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
      let(:log_group_writable?) { true }
      let(:log_write_users) { %w(user1 user2) }
      let(:config) { { 'Misc' => { 'TrustedUser' => 'other1,other2' } } }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:node)
          .and_return(node)
      end

      it 'merges the users with write access into the config' do
        p = provider
        expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
        expect(p).to receive(:owner).with('root')
        expect(p).to receive(:group).with('root')
        expect(p).to receive(:mode).with('0644')
        expect(p).to receive(:lazy).and_yield
        expect(p).to receive(:content).with(
          "[Misc]\nTrustedUser=other1,other2,user1,user2"
        )
        p.action_create
      end
    end

    context 'a duplicate trusted user' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }
      let(:node) { ChefSpec::Macros.stub_node('node.example', platform) }
      let(:log_group_writable?) { true }
      let(:log_write_users) { %w(user1 user2) }
      let(:config) { { 'Misc' => { 'TrustedUser' => 'user1,other1,other2' } } }

      before(:each) do
        allow_any_instance_of(described_class).to receive(:node)
          .and_return(node)
      end

      it 'uniq-ifies the user list before passing it on' do
        p = provider
        expect(p).to receive(:file).with('/etc/samhain/samhainrc').and_yield
        expect(p).to receive(:owner).with('root')
        expect(p).to receive(:group).with('root')
        expect(p).to receive(:mode).with('0644')
        expect(p).to receive(:lazy).and_yield
        expect(p).to receive(:content).with(
          "[Misc]\nTrustedUser=user1,other1,other2,user2"
        )
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
