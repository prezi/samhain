# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_service_ubuntu_trusty'

describe Chef::Provider::SamhainService::Ubuntu::Trusty do
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

    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'Ubuntu 15.04' do
      let(:platform) { { platform: 'ubuntu', version: '15.04' } }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end

    context 'CentOS 7.0' do
      let(:platform) { { platform: 'centos', version: '7.0' } }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end

  describe '#action_create' do
    it 'patches the Samhain init script' do
      p = provider
      expect(p).to receive(:file).with('/etc/init.d/samhain').and_yield
      expect(p).to receive(:owner).with('root')
      expect(p).to receive(:group).with('root')
      expect(p).to receive(:mode).with('0755')
      expect(p).to receive(:lazy).and_yield
      expect(File).to receive(:open).with('/etc/init.d/samhain').and_return(
        double(read: "Hello\npidofproc -p $PIDFILE\nworld")
      )
      expect(p).to receive(:content)
        .with("Hello\npidofproc -p $PIDFILE $DAEMON\nworld")
      p.action_create
    end
  end
end
