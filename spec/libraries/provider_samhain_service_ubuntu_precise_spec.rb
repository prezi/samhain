# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_service_ubuntu_precise'

describe Chef::Provider::SamhainService::Ubuntu::Precise do
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

    context 'Ubuntu 14.04' do
      let(:platform) { { platform: 'ubuntu', version: '14.04' } }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end

  describe '#action_start' do
    before(:each) do
      [:service, :wait_for_samhain_to_start].each do |r|
        allow_any_instance_of(described_class).to receive(r)
      end
    end

    it 'passes the action on to a Chef service resource' do
      p = provider
      expect(p).to receive(:service).with('samhain').and_yield
      expect(p).to receive(:supports).with(restart: true,
                                           reload: true,
                                           status: true)
      expect(p).to receive(:action).with(:start)
      p.send(:action_start)
    end

    it 'waits for Samhain to finish starting' do
      p = provider
      expect(p).to receive(:wait_for_samhain_to_start)
      p.send(:action_start)
    end
  end

  describe '#action_restart' do
    before(:each) do
      [:service, :wait_for_samhain_to_start].each do |r|
        allow_any_instance_of(described_class).to receive(r)
      end
    end

    it 'passes the action on to a Chef service resource' do
      p = provider
      expect(p).to receive(:service).with('samhain').and_yield
      expect(p).to receive(:supports).with(restart: true,
                                           reload: true,
                                           status: true)
      expect(p).to receive(:action).with(:restart)
      p.send(:action_restart)
    end

    it 'waits for Samhain to finish starting' do
      p = provider
      expect(p).to receive(:wait_for_samhain_to_start)
      p.send(:action_restart)
    end
  end

  describe '#wait_for_samhain_to_start' do
    it 'waits for Samhain to finish starting' do
      p = provider
      expect(p).to receive(:ruby_block)
        .with('Wait for Samhain service to start').and_yield
      expect(p).to receive(:block).and_yield
      expect(p).to receive(:shell_out).with('ps h -C samhain').and_return(
        double(stdout: "thing\nthing")
      )
      expect(p).to receive(:retries).with(5)
      expect(p).to receive(:retry_delay).with(1)
      expect(p).to receive(:subscribes).with(:run,
                                             'service[samhain]',
                                             :immediately)
      expect(p).to receive(:action).with(:nothing)
      p.send(:wait_for_samhain_to_start)
    end
  end
end
