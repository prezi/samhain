# Encoding: UTF-8

require_relative '../spec_helper'

describe 'samhain::default' do
  let(:runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'creates a samhain resource' do
    expect(chef_run).to create_samhain('default')
  end
end
