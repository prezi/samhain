# Encoding: UTF-8

require_relative '../spec_helper'
require_relative '../../libraries/provider_samhain_app_ubuntu'

describe Chef::Provider::SamhainApp::Ubuntu do
  let(:name) { 'default' }
  let(:run_context) { ChefSpec::SoloRunner.new.converge.run_context }
  let(:new_resource) { Chef::Resource::SamhainApp.new(name, run_context) }
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

    context 'Debian' do
      let(:platform) { { platform: 'debian', version: '7.6' } }

      it 'returns false' do
        expect(res).to eq(false)
      end
    end
  end

  describe '#install!' do
    let(:source) { nil }
    let(:new_resource) do
      r = super()
      r.source(source) unless source.nil?
      r
    end

    before(:each) do
      allow_any_instance_of(described_class).to receive(:include_recipe)
    end

    shared_examples_for 'any attribute set' do
      it 'ensures the APT cache is up to date' do
        p = provider
        expect(p).to receive(:include_recipe).with('apt')
        p.send(:install!)
      end
    end

    context 'no source attribute' do
      let(:source) { nil }

      it_behaves_like 'any attribute set'

      it 'installs the default Samhain package' do
        p = provider
        expect(p).to receive(:package).with('samhain')
        p.send(:install!)
      end
    end

    context 'a source attribute' do
      let(:source) { '/tmp/package.deb' }

      it_behaves_like 'any attribute set'

      it 'installs the Samhain package from the source' do
        p = provider
        expect(p).to receive(:package).with('/tmp/package.deb')
        p.send(:install!)
      end
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
