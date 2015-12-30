# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_service_ubuntu_legacy'

describe Chef::Provider::SamhainService::Ubuntu::Legacy do
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

    context 'Ubuntu 12.04' do
      let(:platform) { { platform: 'ubuntu', version: '12.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'Ubuntu 10.04' do
      let(:platform) { { platform: 'ubuntu', version: '10.04' } }

      it 'returns true' do
        expect(res).to eq(true)
      end
    end

    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end

  describe '#samhain_service' do
    it 'ignores the status command support in the Samhain service' do
      p = provider
      expect(p).to receive(:service).with('samhain').and_yield
      expect(p).to receive(:supports).with(restart: true,
                                           reload: true,
                                           status: false)
      expect(p).to receive(:action).with([:enable, :start])
      p.send(:samhain_service, [:enable, :start])
    end
  end
end
