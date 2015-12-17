# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::default' do
  let(:platform) { nil }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any platform' do
    it 'creates a samhain resource' do
      expect(chef_run).to create_samhain('default')
    end
  end

  context 'Ubuntu 14.04' do
    let(:platform) { { platform: 'ubuntu', version: '14.04' } }

    it_behaves_like 'any platform'

    it 'repairs the broken Samhain init script' do
      expect(chef_run).to create_file('/etc/init.d/samhain')
    end
  end

  context 'Ubuntu 15.04' do
    let(:platform) { { platform: 'ubuntu', version: '15.04' } }

    it_behaves_like 'any platform'

    it 'leaves the Samhain init script alone' do
      expect(chef_run).to_not create_file('/etc/init.d/samhain')
    end
  end
end
