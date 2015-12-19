# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_app'

describe Chef::Provider::SamhainApp do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SamhainApp.new(name, run_context) }
  let(:provider) { described_class.new(new_resource, run_context) }

  describe '#whyrun_supported?' do
    it 'returns true' do
      expect(provider.whyrun_supported?).to eq(true)
    end
  end

  describe '#action_install' do
    it 'installs the app' do
      p = provider
      expect(p).to receive(:install!)
      p.action_install
    end
  end

  describe '#action_remove' do
    it 'removes the app' do
      p = provider
      expect(p).to receive(:remove!)
      p.action_remove
    end
  end

  describe '#install!' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    context 'no source attribute' do
      let(:source) { nil }

      it 'installs the default Samhain package' do
        p = provider
        expect(p).to receive(:package).with('samhain')
        p.send(:install!)
      end
    end

    context 'a source attribute' do
      let(:source) { '/tmp/package.deb' }

      it 'installs the Samhain package from the source' do
        p = provider
        expect(p).to receive(:package).with('/tmp/package.deb')
        p.send(:install!)
      end
    end
  end

  describe '#remove!' do
    it 'removes the Samhain package' do
      p = provider
      expect(p).to receive(:package).with('samhain').and_yield
      expect(p).to receive(:action).with(:remove)
      p.send(:remove!)
    end
  end
end
