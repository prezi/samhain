# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_app_ubuntu_precise'

describe Chef::Provider::SamhainApp::Ubuntu::Precise do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SamhainApp.new(name, run_context) }
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

  describe '#install!' do
    let(:source) { nil }

    before(:each) do
      allow_any_instance_of(described_class).to receive(:include_recipe)
    end

    it 'ensures the APT cache is up to date' do
      p = provider
      expect(p).to receive(:include_recipe).with('apt')
      p.send(:install!)
    end

    it 'installs the default Samhain package' do
      p = provider
      expect(p).to receive(:package).with('samhain')
      p.send(:install!)
    end

    it 'waits for the package install action to complete' do
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
                                             'package[samhain]',
                                             :immediately)
      expect(p).to receive(:action).with(:nothing)
      p.send(:install!)
    end
  end

  describe '#remove!' do
    before(:each) do
      allow_any_instance_of(described_class).to receive(:package)
    end

    it 'purges the Samhain package' do
      p = provider
      expect(p).to receive(:package).with('samhain').and_yield
      expect(p).to receive(:action).with(:purge)
      p.send(:remove!)
    end
  end
end
